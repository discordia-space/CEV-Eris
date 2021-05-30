/**
 * @file
 * @copyright 2021 LetterN
 * @license MIT
 */

import { createLogger } from 'tgui/logging';
import RPC from "discord-rpc";

const logger = createLogger('richPresence');
const RPC_ID = "440289271580983308"; // has to be str
RPC.register(RPC_ID); // feed it before the middleware even inits

// reducer: hides the props
// middleware: does stuff, callable and is basicaly a state cmp

export const RPCMiddleware = store => {
  const { type, payload } = action;
  let initialized = false;
  let rpcInitialized = false; // we need to wait for the cb(t)
  /** @type {RPC.Client} this exists because eslint :b:roke */
  let client = null;
  let interval;

  function setActivity(data){
    logger.log("Updating RP.");
    let activity = {
      // Logo of the server
      "largeImage": data.serverImage || "ss13",
      // Name
      "largeText": data.serverName,
      // SS13 game
      "smallImage": "ss13",
      "smallText": "Space Station 13",
      // Cur players
      "partySize": data.pop || 1,
      // maxpop
      "partyMax": data.maxPop || 50,
      // server link
      "joinSecret": data.url,
      // REQUIRED IF LINK IS ENABLED
      "partyID": "server name + map name + roundid + SSTgui pepper",
      // Round started?
      "instance": false,
      // are we on lobby, playing, or observing.
      "state": "3 states",
      // date.now - server time since start (wtf we can just use that)
      "start": Date.now(),
    };
    activity["details"] = "Map: NAME";
    // do not show if it doesn't exist
    activity["details"] += " | Gamemode: UNKN";
    // do not show if it doesn't exist
    activity["details"] += " | Round id: ROUNDID";
    client.setActivity(activity).catch(logger.error);
  };

  return next => action => {

    if(!initialized || !client){
      initialized = true;
      client = new RPC.Client({ transport: 'ipc' });
      client.login({ clientId: RPC_ID }).catch(logger.error);
      logger.info("RPC Initialized, waiting for the IPC connection.");
      client.on('ready', () => {
        rpcInitialized = true;
        logger.info("IPC connection started.");
      });
    }
    if (type === 'RPC/update') {
      //payload contains server info
      return;
    }
    return next(action);
  };
};
