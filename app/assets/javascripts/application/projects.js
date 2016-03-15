function onTestChange() {
    var key = window.event.keyCode;

    // If the user has pressed enter
    if (key == 13) {
        $(".message-send-button").click();
        return false;
}}
