
/*
 *  EBT Scrapping Java Script
 */
 
 // Ctrl + U
 // class -> .
 // id -> #


//    let jsSubmit = "void($('form')[1].submit())"
//    let jsGetAllElements = "document.documentElement.outerHTML"
//    let jsGetErrorCode = "$(\".errorInvalidField\").text().trim();"



function getMyName() {
    return 'kiran';
}

function appendTwoStrings(x, y) {
    
    return "\(x)" + " " + y;
}

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
    
    var errorHeading = "";
    if(document.getElementById('errorTable') &&
       document.getElementsByClassName('errorText') &&
       document.getElementsByClassName('errorText').length > 0) {
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
    else {
        if (document.getElementById('errorTable').style.display != 'none') {
            return errorHeading;
        } else {
            return "";
        }
    }
}



function identifyPage() {
    if ($('#txtCardNumber').length && $('#btnValidateCardNumber').length) return 'sign_up_card';
    if ($('#btnAcceptTandC').length && $('#btnCancelRegistration').length) return 'sign_up_terms_conditions';
    if ($('#btnValidateSecurityAnswer').length && $('#txtSecurityKeyQuestionAnswer').length && $('input.birthDate').length) return 'sign_up_dob';
    if ($('#txtNewPin').length && $('#txtConfirmPin').length) return 'sign_up_select_pin';
    if ($('#txtConfirmEmail').length && $('select#question2').length) return 'sign_up_user_information';
    if ($('#txtEmailValidationCode').length && ('#validateEmailBtn').length && $('#changeEmailBtn').length) return 'sign_up_user_confirmation';
    if ($('#currentEmailLbl').length && $('#newEMailTextField').length && $('#validateEMailTextField').length) return 'sign_up_change_email';
    if ($('#userId').length && $('#password').length && $('#button_logon').length) return 'login';
    if ($('#txtAuthenticationCode').length && $('#okButton').length && $('#cancelBtn').length) return 'login_authorization';
    if ($('#securityAnswer').length && $('#registerDeviceFlag').length && $('#okButton').length) return 'login_security_question';
    if ($($('#port_panel_02b ul li.green_bullet')[1]).children('strong').length > 0) return 'account_transactions';
    if ($('#subHeadercardholderSummary').length ) return 'account_dashboard';
    if ($("#errorTable p.errorText:contains('Please try again later')").length) return 'error';
    return "";
}


function checkForSuccessMessage() {
    return $('#actionMsg .completionText').text().trim();
}

function getPageHeader() {
    return $('.PageHeader').first().text().trim();
}

function getPageTitle() {
    return $('.PageTitle').first().text().trim();
}


// Login
function autofillLoginDetailsAndSubmit(userName, password) {
    
    $('#userId').val(userName);
    $('#password').val(password);
    $('#submit').click();
}

function checkForLoginStatusMessage() {
    return $('#infoMsg .actionMessage').text().trim();
}

// Authentication code
function autofillAuthenticationCodeAndSubmit(authenticationCode) {
    
    $('#txtAuthenticationCode').val(authenticationCode);
    $('#okButton').click();
}

function clickRegenerateButton() {
    return $('#cancelBtn').click();
}

// security question
function getSecurityQuestion() {
    return $('.cdpLeftAlignedTdLabel').first().text().trim();
}

function autoFillSecurityAnswerAndSubmit(securityQuestion) {
    $('#securityAnswer').val(securityQuestion);
    $('#okButton').click();
}




