
/*
 *  EBT Scrapping Java Script
 */
 
 // Ctrl + U
 // class -> .
 // id -> #


//    let jsSubmit = "void($('form')[1].submit())"
//    let jsGetAllElements = "document.documentElement.outerHTML"
//    let jsGetErrorCode = "$(\".errorInvalidField\").text().trim();"


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
        if (document.getElementById('errorTable') &&
            document.getElementById('errorTable').style.display != 'none') {
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


// MARK: -  Login
function autofillLoginDetailsAndSubmit(userName, password) {
    
    $('#userId').val(userName);
    $('#password').val(password);
    $('#submit').click();
}

function isSpanishPageLoaded() {
    var selectedLanguage = $('#sample').children().children().children().children('label').text();
    if (selectedLanguage) {
        if (selectedLanguage != "Idioma") {
            return false;
        } else {
            return true;
        }
    }
    return true;
}


function checkForLoginStatusMessage() {
    return $('#infoMsg .actionMessage').text().trim();
}

// MARK: -  Authentication code
function autofillAuthenticationCodeAndSubmit(authenticationCode) {
    
    $('#txtAuthenticationCode').val(authenticationCode);
    $('#okButton').click();
}

function clickRegenerateButton() {
    return $('#cancelBtn').click();
}

// MARK: -  security question
function getSecurityQuestion() {
    return $('.cdpLeftAlignedTdLabel').first().text().trim();
}

function autoFillSecurityAnswerAndSubmit(securityQuestion) {
    $('#securityAnswer').val(securityQuestion);
    $('#okButton').click();
}

// MARK: - Dashboard
function getSnapBalance() {
    return $($("td.widgetValue:contains('SNAP')").parent().parent().find('td.widgetValue')[2]).html().trim();
}

function getCashBalance() {
    return $($("td.widgetValue:contains('CASH')").parent().parent().find('td.widgetValue')[2]).html().trim();
}

function getTransactionsPageURL() {
    return $('.green_bullet:eq(1) a').attr('href');
}

function loadTransactionsPage(url) {
    window.location.href = url;
}

function validateTransactionsTab() {
    return $('#transActTabs li.ui-state-active').attr('id');
}

function clickTransactionsTab() {
    $('#allactTab a').click();
}

function validateTransactionsTabClick() {
    return $('#transActTabs li.ui-state-active').attr('id');
}

function checkForStartEndDateFields() {
    return $('#fromDateTransHistory').attr('id');
}


function setTransactionsHistoryStartEndDates() {
    
   var formatD = function(d) {
    var dd = d.getDate(),
    dm = d.getMonth()+1,
    dy = d.getFullYear();
    if (dd<10) dd='0'+dd;
    if (dm<10) dm='0'+dm;
    return dm+'/'+dd+'/'+dy;
    };
    var endDate = new Date(), startDate = new Date(endDate.valueOf());
    startDate.setDate(endDate.getDate()-90);
    $('#fromDateTransHistory').val(formatD(startDate));
    $('#toDateTransHistory').val(formatD(endDate));
    $('#searchAll').click()
}

function getCurrentPageNumber() {
    return $('.ui-pg-input').val();
}
    
function getTransactions() {
    var list = [];
    var table = $('#allCompletedTxnGrid tbody');
    table.find('tr').each(function (i) {
                          var $tds = $(this).find('td'),
                          t_date = $tds.eq(2).text().trim();
                          if (t_date) {
                            list[i] = {
                                id: this.id,
                                date: t_date,
                                transaction: $tds.eq(3).text().trim(),
                                location: $tds.eq(4).text().trim(),
                                account: $tds.eq(5).text().trim(),
                                card: $tds.eq(6).text().trim(),
                                debit_amount: $tds.eq(7).text().trim(),
                                credit_amount: $tds.eq(8).text().trim(),
                                available_balance: $tds.eq(9).text().trim()
                            };
                          }
    });
    arr = $.grep(list, function (n) {
            return n == 0 || n;
    });
    var jsonSerialized = JSON.stringify(arr);
    return jsonSerialized;
}

function isLastPage() {
    return $('#next_allCompletedTxnGrid_pager.ui-state-disabled').attr('id');
}

function gotoNextPage() {
    $('#next_allCompletedTxnGrid_pager > a').click();
}











