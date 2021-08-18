require(Modules.CallList);
require(Modules.AI);
require(Modules.Player);
require(Modules.IVR);

let item;
let call;
const callerId = '74953746438';

VoxEngine.addEventListener(AppEvents.Started, () => {
    item = JSON.parse(VoxEngine.customData());
    call = VoxEngine.callPSTN(item.phoneNumber, callerId);
    call.addEventListener(CallEvents.AudioStarted, () => {
        AI.detectVoicemail(call).catch(()=>{});
    });
    call.addEventListener(CallEvents.Connected, handleCallConnected);
    call.addEventListener(CallEvents.Failed, handleCallFailed);
    call.addEventListener(CallEvents.Disconnected, handleCallDisconnected);
    call.addEventListener(AI.Events.VoicemailDetected, voicemailDetected);
});

function voicemailDetected(e) {
    if (e.confidence >= 75) {
        CallList.reportError('VoiceMail', () => {
            sendCallInfoToServer({
                status: 'voicemail',
                id: item.callResultId
            }, VoxEngine.terminate);
        });
    }
}

function handleCallConnected(e) {
    sendCallInfoToServer({
        status: 'connected',
        id: item.callResultId
    });
    setTimeout(() => {
        const player = VoxEngine.createURLPlayer(item.messageUrl, false);
        player.sendMediaTo(call);
        player.addEventListener(PlayerEvents.PlaybackFinished, () => {
            player.removeEventListener(CallEvents.PlaybackFinished);
            sendCallInfoToServer({
                status: 'message_played',
                id: item.callResultId
            });
            ivr(call);
        });
    }, 100);
}

function ivr(call) {
    const repeatState = new IVRState("repeat", {
        type: 'noinput',
        prompt: {
            say: ''
        },
    }, () => {
        sendCallInfoToServer({
            id: item.callResultId,
            user_input: 1
        });
        const player = VoxEngine.createURLPlayer(item.messageUrl, false);
        player.sendMediaTo(call);
        player.addEventListener(PlayerEvents.PlaybackFinished, () => {
            player.removeEventListener(CallEvents.PlaybackFinished);
            call.hangup();
        });
    });

    const goodbyeState = new IVRState("goodbye", {
        type: 'noinput',
        prompt: {
            play: 'https://www.cosmeticru.com/uploads/ivr/callback.mp3'
        },
    }, () => {
        sendCallInfoToServer({
            id: item.callResultId,
            user_input: 2
        });
        call.hangup();
    });

    const mainState = new IVRState("main", {
        type: 'select',
        prompt: {
            play: item.ivrPromptUrl
        },
        nextStates: {
            '1': repeatState,
            '2': goodbyeState
        }
    }, null, () => {
        const player = VoxEngine.createURLPlayer('https://www.cosmeticru.com/uploads/ivr/bye.mp3', false);
        player.sendMediaTo(call);
        player.addEventListener(PlayerEvents.PlaybackFinished, () => {
            player.removeEventListener(CallEvents.PlaybackFinished);
            call.hangup();
        });
    });

    mainState.enter(call);
}

function handleCallDisconnected(e) {
    CallList.reportResult({
        result: true,
        duration: e.duration
    }, () => {
        sendCallInfoToServer({
            id: item.callResultId,
            duration: e.duration
        }, VoxEngine.terminate);
    });
}

function handleCallFailed(e) {
    CallList.reportError({
        result: false,
        msg: 'Failed',
        code: e.code
    }, () => {
        sendCallInfoToServer({
            status: 'failed',
            id: item.callResultId,
            duration: e.duration,
            code: e.code
        }, VoxEngine.terminate);
    });
}

function sendCallInfoToServer(params, callback = null) {
    const request = Net.httpRequestAsync(item.webhookUrl, {
            method: 'POST',
            params: params
        }
    );

    request.catch((error) => {
        console.log(error);
    });

    if (callback) {
        request.then(callback);
    }
}