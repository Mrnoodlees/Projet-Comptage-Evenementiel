let accessVersion = 1

export const getAccessVersion = () => accessVersion

export const bumpAccessVersion = () => {
  accessVersion += 1
  return accessVersion
}
