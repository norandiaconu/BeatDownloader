#!/usr/bin/env node
import fetch from "node-fetch";
import { createRequire } from "module";
const require = createRequire(import.meta.url);
const shellExec = require("child_process");
const fs = require("fs");
const storage = require("node-persist");
const readline = require("readline");

main();
async function main() {
    var directory = process.argv.slice(2).join(" ");
    await storage.init();
    if (!directory) {
        const loadDir = await storage.getItem("directory");
        if (loadDir) {
            directory = loadDir;
        } else {
            directory = "C:/Program Files (x86)/Steam/steamapps/common/Beat Saber/Beat Saber_Data/CustomLevels";
        }
    }
    if (!fs.existsSync(directory)) {
        console.log("Unavailable directory selected, exiting");
        return;
    }
    console.log("Using the following directory to save maps:\n", directory);
    await storage.setItem("directory", directory);

    let page = await storage.getItem("page");
    if (page) {
        const answer = await restart("Do you want to continue the previous run on page " + page + "? (Enter y/n followed by ENTER key)");
        if (answer !== "y") {
            page = 1;
            await storage.removeItem("page");
        } else {
            console.log("Continuing from page", page);
        }
    } else {
        page = 1;
    }

    let response;
    let responses = [];
    let runString;

    while (page <= 99) {
        response = await getURL(page);
        if (!response) {
            console.log("Error in page " + page + " response, exiting run");
            return;
        }
        responses = response.maps;
        if (!responses.length) {
            console.log("No more maps found, exiting run");
            return;
        }
        runString = "";

        for (const one of responses) {
            var files = fs.readdirSync(directory).filter((fn) => fn.startsWith(one.key));
            if (!files.length) {
                runString = "start beatsaver://" + one.key;
                console.log("Downloading", one.key);
                shellExec.exec(runString);
                await sleep(8000);
            } else {
                console.log("Skipping", one.key);
            }
        }
        page = page + 1;
        await storage.setItem("page", page);
        await sleep(8000);
    }
}

async function getURL(urlPage) {
    let body = '{"page":' + urlPage + ',"minStar":0,"maxStar":14,"sortBy":"date","search":""}';
    let res = await fetch("https://beat-savior.herokuapp.com/api/maps/ranked/", {
        headers: {
            "content-type": "application/json;charset=UTF-8",
        },
        body: body,
        method: "POST",
    });
    if (res.status === 200) {
        console.log("Fetched page", urlPage);
        return res.json();
    } else {
        console.log("Error fetching page " + urlPage + ", exiting run");
        return;
    }
}

function restart(query) {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });
    return new Promise((resolve) =>
        rl.question(query, (ans) => {
            rl.close();
            resolve(ans);
        })
    );
}

async function sleep(ms) {
    return new Promise((res) => setTimeout(res, ms));
}
