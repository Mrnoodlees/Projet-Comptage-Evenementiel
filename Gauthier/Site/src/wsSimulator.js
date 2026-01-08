// src/wsSimulator.js
export function startSimulation(socket) {
  setInterval(() => {
    const msg = {
      currentPeople: Math.floor(Math.random() * 100),
      entries: Math.floor(Math.random() * 10),
      exits: Math.floor(Math.random() * 10),
      battery: Math.floor(Math.random() * 100),
      status: ["OK", "WARN", "ERROR"][Math.floor(Math.random() * 3)],
      timestamp: new Date().toLocaleTimeString()
    };
    socket.onmessage({ data: JSON.stringify(msg) });
  }, 1000);
}
