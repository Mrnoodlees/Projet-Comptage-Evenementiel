import { spawn } from 'node:child_process'

const processes = new Map()
const isWin = process.platform === 'win32'
let exitRequested = false

const killProcessTree = (child, signal = 'SIGTERM') => {
  if (!child || child.killed || !child.pid) return

  if (isWin) {
    // Force-stop entire tree on Windows to free ports reliably.
    spawn('taskkill', ['/PID', String(child.pid), '/T', '/F'], { stdio: 'ignore' })
    return
  }

  try {
    // Kill the whole process group (requires detached: true).
    process.kill(-child.pid, signal)
  } catch {
    child.kill(signal)
  }
}

const stopAll = (signal = 'SIGTERM') => {
  for (const child of processes.values()) {
    killProcessTree(child, signal)
  }
}

const requestExit = (code = 0) => {
  if (exitRequested) return
  exitRequested = true
  stopAll('SIGTERM')
  process.exit(code)
}

const startProcess = ({ name, command, args }) => {
  const child = spawn(command, args, {
    stdio: 'inherit',
    shell: isWin,
    detached: !isWin
  })

  processes.set(name, child)

  child.on('exit', (code, signal) => {
    if (signal) {
      return
    }

    if (code && code !== 0) {
      console.error(`[run] ${name} s'est arrêté (code ${code}).`)
      requestExit(code)
      return
    }

    // Si l'un des deux s'arrête proprement, on coupe l'autre aussi.
    requestExit(0)
  })
}

const main = () => {
  startProcess({
    name: 'api',
    command: 'npm',
    args: ['run', 'api']
  })

  startProcess({
    name: 'front',
    command: 'npm',
    args: ['run', 'dev', '--', '--host', '0.0.0.0']
  })

  process.on('SIGINT', () => requestExit(0))
  process.on('SIGTERM', () => requestExit(0))
  process.on('SIGBREAK', () => requestExit(0))
  process.on('exit', () => stopAll('SIGTERM'))
}

main()
