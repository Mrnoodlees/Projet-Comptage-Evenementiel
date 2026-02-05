import { spawn } from 'node:child_process'

const processes = new Map()

const startProcess = ({ name, command, args }) => {
  const child = spawn(command, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32'
  })

  processes.set(name, child)

  child.on('exit', (code, signal) => {
    if (signal) {
      return
    }

    if (code && code !== 0) {
      console.error(`[run] ${name} s'est arrêté (code ${code}).`)
      stopAll()
      process.exit(code)
    }

    // Si l'un des deux s'arrête proprement, on coupe l'autre aussi.
    stopAll()
    process.exit(0)
  })
}

const stopAll = (signal = 'SIGTERM') => {
  for (const child of processes.values()) {
    if (!child.killed) {
      child.kill(signal)
    }
  }
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
    args: ['run', 'dev']
  })

  process.on('SIGINT', () => stopAll('SIGINT'))
  process.on('SIGTERM', () => stopAll('SIGTERM'))
}

main()
