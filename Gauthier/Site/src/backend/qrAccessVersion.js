let accessVersion = 1

// Version globale gardée en mémoire pour invalider les sessions QR ouvertes.
export const getAccessVersion = () => accessVersion

export const bumpAccessVersion = () => {
  // Chaque reset admin augmente la version ; les navigateurs comparent cette valeur.
  accessVersion += 1
  return accessVersion
}
