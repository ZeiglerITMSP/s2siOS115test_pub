


function getMyName() {
    return 'kiran';
}

function appendTwoStrings(x, y) {
    
    return x + " " + y;
}


//function getErrorMessage() {
//    var errorTable = document.getElementById('errorTable').getElementsByClassName('errorText')[0].innerText.trim();
//    return errorTable;
//}


//function getErrorMessage() {
//    var errorInvalidField = $('.errorInvalidField').first().text().trim();
//    var errorLoginField = $('.errorTextLogin').text().trim();
//    var vallidationExcpMsg = $('#VallidationExcpMsg').first().text().trim();
//    var errorHeading = $('.errorText').first().text().trim();
//    if(errorHeading) {
//        errorHeading = errorHeading.trim() + "\n\n";
//    } else {
//        errorHeading = "";
//    }
//    
//    if(vallidationExcpMsg || vallidationExcpMsg.length>0){
//        return errorHeading + vallidationExcpMsg.trim();
//    } else if(errorInvalidField || errorInvalidField.length>0) {
//        return errorHeading + errorInvalidField.trim();
//    } else if(errorLoginField || errorLoginField.length>0) {
//        return errorHeading + errorLoginField.trim();
//    }
//}

function getErrorMessage() {

    var errorInvalidField = "";
    if(document.getElementsByClassName('errorInvalidField') && document.getElementsByClassName('errorInvalidField').length > 0){
        errorInvalidField = document.getElementsByClassName('errorInvalidField')[0].innerText.trim();
    }
    var errorLoginField = "";
    if(document.getElementsByClassName('errorTextLogin') && document.getElementsByClassName('errorTextLogin').length > 0){
        errorLoginField = document.getElementsByClassName('errorTextLogin')[0].innerText.trim();
    }
    var vallidationExcpMsg = "";
    if(document.getElementById('VallidationExcpMsg')){
        vallidationExcpMsg = document.getElementById('VallidationExcpMsg').innerText.trim();
    }
    
    var errorHeading = ""
    if(document.getElementById('errorTable') && document.getElementsByClassName('errorText') && document.getElementsByClassName('errorText').length > 0){
        errorHeading = document.getElementById('errorTable').getElementsByClassName('errorText')[0].innerText.trim();
    }
    
    if(errorHeading) {
        errorHeading = errorHeading.trim() + "\n\n";
    } else {
        errorHeading = "";
    }

    if(vallidationExcpMsg || vallidationExcpMsg.length>0){
        return errorHeading + vallidationExcpMsg.trim();
    } else if(errorInvalidField || errorInvalidField.length>0) {
        return errorHeading + errorInvalidField.trim();
    } else if(errorLoginField || errorLoginField.length>0) {
        return errorHeading + errorLoginField.trim();
    }
    else {  return errorHeading; }
}



