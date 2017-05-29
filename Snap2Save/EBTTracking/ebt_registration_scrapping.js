/*
 *  EBT Registration Scrapping Java Script
 */


// MARK: - Card Number

function autoFillCardNumber(cardNumber) {
    $('#txtCardNumber').val(cardNumber);
    void($('#btnValidateCardNumber').click());
}

// MARK: - Accept terms
function acceptTerms() {
    void($('form')[1].submit());
}

// MARK: - DOB
function getQuestionsFromDOBpage() {
    return $("label[for='securityAnswer']").text().trim();
}

function autoFillDOBandSecurityQuestion(dob, securityAnswer) {
    
    $('#txtSecurityKeyQuestionAnswer').val(dob);
    $('#txtSecurityKeyQuestionAns_0').val(securityAnswer);
    void($('#btnValidateSecurityAnswer').click());
}


// MARK: - PIN

function autoFillPin(newPin, confirmPin) {
    
    $('#txtNewPin').val(newPin);
    $('#txtConfirmPin').val(confirmPin);
    void($('#btnPinSetup').click());
}

function useCurrentPin() {
    
    $('#btnUseCurrentPin').click();
}

//MARK: - User Information

function getUserIdRules() {
    
   return $('.prelogonInstrText:eq(2)').text().trim();
}

function getPasswordRules() {
    return $('.prelogonInstrText:eq(4)').text().trim();
}

function getQuestion1Options() {
    var object = {};
    $('#question1 option').each(function () {
        object[$(this).val()] = $(this).text().trim();
    });
    var jsonSerialized = JSON.stringify(object);
    return jsonSerialized;
}

function getQuestion2Options() {
    var object = {};
    $('#question2 option').each(function () {
                                object[$(this).val()] = $(this).text().trim();
                                });
    var jsonSerialized = JSON.stringify(object);
    return jsonSerialized;
}


function getQuestion3Options() {
    var object = {};
    $('#question3 option').each(function () {
        object[$(this).val()] = $(this).text().trim();
    });
    var jsonSerialized = JSON.stringify(object);
    return jsonSerialized;
}


function autofillUserInformation(userId, password, confirmPassword, emailAddress, confirmEmail, phoneNumber, questionOneIndex, questionTwoIndex, questionThreeIndex, answerOne, answerTwo, answerThree) {
    
    $('#txtUserid').val(userId);
    $('#txtPassword').val(password);
    $('#txtConfirmPassword').val(confirmPassword);
    $('#txtEmail').val(emailAddress);
    $('#txtConfirmEmail').val(confirmEmail);
    $('#txtPhoneNumber').val(phoneNumber);
    
    $('#question1').val(questionOneIndex);
    $('#question2').val(questionTwoIndex);
    $('#question3').val(questionThreeIndex);
    
    $('#response1TextField1').val(answerOne);
    $('#response1TextField2').val(answerTwo);
    $('#response1TextField3').val(answerThree);
    
    $('#chkElecCommsOpt').prop('checked', true);
    
    void($('#btnValidateUserInfo').click());
}


// MARK: - Confirmation

function autofillConfirmationCode(valdationCode) {
    $('#txtEmailValidationCode').val(valdationCode);
    void($('#validateEmailBtn').click());
}

function resendVerficationCode() {
    void($('#resendValidationCodeBtn').click());
}

function getEmailConfirmation() {
    var names = '';
    var msgDescription = $('#emailValidationForm .prelogonInstrTextArea .prelogonInstrText');
    msgDescription.each(function(i, object) {
                        if (i != 0) {
                            names += object.innerText.trim();
                        }
                        if (i == 1) {
                            names += '. '
                        }
    });
    return names;
}

function changeEmail() {
    void($('#changeEmailBtn').click());
}

function getCurrentEmailAddress() {
    return $('#currentEmailLbl').text().trim();
}

function autoFillChangeEmail(emailAddress, confirmEmail) {
    
    $('#newEMailTextField').val(emailAddress);
    $('#validateEMailTextField').val(confirmEmail);
    
    void($('#changeEmailBtn').click());
}





















