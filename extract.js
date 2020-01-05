/**
 * @author Mm2PL
 * @description Extract code from SQL files.
 */

'use strict';
const fs = require('fs');
const util = require('util');
const path = require('path');

const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);
const mkdir = util.promisify(fs.mkdir);
const unlink = util.promisify(fs.unlink);

const regex = /.*\nON\sDUPLICATE\sKEY\sUPDATE\n\tCode\s=\s'(.*)'/msu;
const unescapeRegexs = [
    [/\\"/gmsu, "\""],
    [/\\\\/gmsu, "\\"],
];

async function extractFromFile(fileName, output) {
    let data = await readFile(fileName);
    let code = data.toString().replace(regex, "$1");
    for (let i = 0; i < unescapeRegexs.length; i++) {
        code = code.replace(unescapeRegexs[i][0], unescapeRegexs[i][1]);
    }
    await writeFile(output, code);
}

async function main() {
    try {
        await mkdir("js");
    } catch (e) {
        const toRemove = fs.readdirSync("js");
        for (let i = 0; i < toRemove.length; i++) {
            let unlinkName = path.join("js", toRemove[i]);
            console.log(`unlink ${unlinkName}`);
            await unlink(unlinkName);
        }

    }
    const commands = fs.readdirSync("commands");
    for (let i = 0; i < commands.length; i++) {
        let new_name = commands[i].replace(".sql", ".js");

        console.log(`Converting ${commands[i]} to ${new_name}`);
        await extractFromFile(path.join("commands", commands[i]), path.join("js", new_name));
    }
    return 'done!';
}

main().then(r => console.log(r));
module.exports = {extractFromFile: extractFromFile};