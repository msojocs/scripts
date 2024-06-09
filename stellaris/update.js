const { execSync } = require('child_process')
const path = require('path')
const fs = require('fs')
const os = require('os')

const modListData = fs.readFileSync(path.resolve(__dirname, './mod_list.txt')).toString().replace(/\r/g, '')
const modList = modListData.split('\n')
let steamParam = ''

const steamcmdPath = execSync('where steamcmd').toString()
console.log('steamcmd path:', steamcmdPath)

for (const mod of modList) {
    steamParam += ` +workshop_download_item 281990 ${mod} `
}
console.log('cmd list:', steamParam)

execSync(`steamcmd +login anonymous ${steamParam} +quit`, {
    stdio: 'inherit'
})

const contentPath = path.resolve(steamcmdPath, '../steamapps/workshop/content/281990')
console.log('content path:', contentPath)

const home = os.homedir()
const targetPath = path.resolve(home, 'Documents/Paradox Interactive/Stellaris/mod')
console.log('target path:', targetPath)


for (const modId of modList) {
    console.log(`---------------${modId}---------------------`)
    let modData = fs.readFileSync(`${contentPath}/${modId}/descriptor.mod`).toString().replace(/\r/g, '')
    console.log('mod data:', modData)
    let modDetail = modData.split('\n').filter(e => !e.startsWith('path'))
    modDetail.splice(modDetail.length - 1, 0, `path="${contentPath}/${modId}"`.replace(/\\/g, '/'))
    console.log(`${targetPath}/${modId}.mod result:`, modDetail)
    fs.writeFileSync(`${targetPath}/${modId}.mod`, modDetail.join('\n'))
}