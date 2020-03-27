/*Pages specific JS*/
(function(){

  'use strict';


  rm.domReady.done(function () {
  if (!rm.globals.DOM.body.hasClass('ca-landing') && ! rm.globals.DOM.body.hasClass('ca-landing1')) return;
    var slr = {
          showEmty: '.display--emptytable',
          showFill: '.display--filledtable',
          sysErr: '.error--system-error',
          sysErrText: '.error--system-error .alert__message__content',
          tb: '#ca-linked-records',
          tbEmpty: '#ca-linked-records--empty',
          lastLog: '.last-logged-in span',
          noRecords: '.no-linked-records',
          msg_content: 'p.alert__content'
        },
        cls = {
          hide: 'hidden'
        },
        txt = {
          lastLog: 'You last logged in on '
        },
        $modal = $("#modalAcceptanceTransfer");

        $(slr.showFill).addClass(cls.hide);
        rm.ajaxLoader.showAjaxLoader("Loading, please wait...");
    var caRecordAjaxTb = rm.ajaxTb.create(),
        jsonToAttrMap = [
          {
            jsonPropName: 'ihi',
            targetElem: false,
            targetAttr: 'data-ihi'
          },
          {
            jsonPropName: 'name',
            targetElem: 'td:nth-child(1) span',
            targetAttr: false
          },
          {
            jsonPropName: 'name',
            targetElem: 'td:nth-child(1)',
            targetAttr: 'data-search'
          },
          {
            jsonPropName: 'dob',
            targetElem: 'td:nth-child(2) span',
            targetAttr: false
          },
          {
            jsonPropName: 'dobTime',
            targetElem: 'td:nth-child(2)',
            targetAttr: 'data-order'
          },
          {
            jsonPropName: 'age',
            targetElem: 'td:nth-child(3) span',
            targetAttr: false
          },
          {
            jsonPropName: 'ageMonth',
            targetElem: 'td:nth-child(3)',
            targetAttr: 'data-order'
          },
          {
            jsonPropName: 'sex',
            targetElem: 'td:nth-child(4) span',
            targetAttr: false
          },
          {
            jsonPropName: 'representativeType',
            targetElem: 'td:nth-child(6) span',
            targetAttr: false
          },
          {
            jsonPropName: 'relationShipType',
            targetElem: 'td:nth-child(6) .relationShipType',
            targetAttr: false
          },
          {
            jsonPropName: 'ihi',
            targetElem: 'td:nth-child(5) span',
            targetAttr: false
          },
          {
            jsonPropName: 'recordStatus',
            targetElem: false,
            targetAttr: 'data-status'
          },
          {
            jsonPropName: 'restrictionStatus',
            targetElem: 'td:nth-child(7) span',
            targetAttr: false
          },
          {
            jsonPropName: 'manageRestrition',
            targetElem: 'td:nth-child(8) span',
            targetAttr: false
          }
        ];

        // setting table page length for mobile view
        if($(window).width() <= 767){
          $("#ca-linked-records").attr("data-page-length",'5');
        }
    var jsonDataDummy = './ncp/checkCarerIdentity/table-form_ca-records-data.json';

    if(rm.globals.DOM.body.hasClass('ca-landing1')){
      jsonDataDummy = './ncp/checkCarerIdentity/table-form_ca-records-data--error-repre.json';
    }
    var dataFilter = function(tbData){
        return $.map(tbData, function(item){
            if(item.restrictionStatus === "Restricted"){
                item.manageRestrition = '<a href="ca-restriction-in-place.html" class="info__link">Manage Restriction</a>';
            } else {
                item.manageRestrition = '<a href="cae-add-restriction.html" class="info__link">Add Restriction</a>';
            }
            return item;
        });

    }

    caRecordAjaxTb.init('#ca-linked-records', jsonDataDummy, jsonToAttrMap, dataFilter)
    .fail(function (err) {
        console.log(err);
        rm.ajaxLoader.hideAjaxLoader();
      })
    .done(function(respData) {
        console.log(respData);
        if (!caRecordAjaxTb.state.jsonData) {
          //Empty table
          $(slr.showEmty).removeClass(cls.hide);
          $(slr.showFill).addClass(cls.hide);
          switch (respData.errorCode) {
            case 'FAILED_TECH':
              $(slr.sysErrText).html(respData.errorMessage);
              $(slr.sysErr).removeClass(cls.hide);
              $(slr.tb).addClass(cls.hide);
              $(slr.tbEmpty).addClass(cls.hide);
              rm.ajaxLoader.hideAjaxLoader();
              break;
            case 'FAILED':
              $(slr.tbEmpty).addClass(cls.hide);
              $(slr.msg_content).html(respData.errorMessage)
              $(slr.noRecords).removeClass(cls.hide);
              rm.ajaxLoader.hideAjaxLoader();
              break;
          }
        } else {
          $(slr.showEmty).addClass(cls.hide);
          $(slr.showFill).removeClass(cls.hide);
          disableSuspendedRecord();
          rm.ajaxLoader.hideAjaxLoader();
        }
        $(slr.lastLog).html(txt.lastLog + respData.lastUpdated);
        var $tb = $('#ca-linked-records');
        rm.table.initDataTable($tb);
        rm.tbMobileSort.init({
          wrap: '.js-m-datatable-sort--custom',
          th: '#ca-linked-records thead th'
        });
        rm.tbSearch.init($tb);

        // This is for Acceptance of Transfer Modal
        $modal.modal("show");
      });
      function disableSuspendedRecord(){
        var $tr = $(slr.tb).find('tbody > tr')
        $tr.each(function(ind,$item){
          var status = $($item).data('status');
          if(status === 'Suspended'){
            $($item).attr('disabled','disabled');
          }
        });
      }
  });
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('ca-passphrase')) return;

    rm.domReady.done(function() {
        var slr = {
            frmPass: '#formCAPassphrase',
            passphrase: 'input[name="passphrase"]',
            modSuccess: '#modalPassphraseSuccess',
            btnModOk: '#modalPassphraseSuccess #btnContinue',
            alertErr: '.error--system-error',
            errMsg: '.error--system-error .alert__message'
        };

        // Save passphase
        $(slr.frmPass).on('success.form.fv', function(e) {
            e.preventDefault();
            var pass = $(slr.passphrase).val();
            var encodedPassphrase = encodeURIComponent(pass);
            $.ajax({
                type: 'POST',
                url: '/ncp/updateCarerDetails',
                data: 'passphrase=' + encodedPassphrase,
                dataType: "text",
                success: function(response) {
                    rm.dirtyforms.cleanForm("#formCAPassphrase"); 
                    var result = jQuery.parseJSON(response);
                    if (result.responseCode === 'PCEHR_SUCCESS') {
                        $(slr.alertErr).addClass('hidden');
                        $(slr.modSuccess).modal('show');
                    } else {
                        $(slr.errMsg).html(result.errorMessage);
                        $(slr.alertErr).removeClass('hidden');
                    }
                },
                error: function(e) {

                },
                complete: function() {
                    rm.dirtyforms.cleanForm("#formCAPassphrase"); 
                    $(slr.alertErr).addClass('hidden');
                    $(slr.modSuccess).modal('show');
                }

            });
        });        
            
        // Modal for update passphrase
        $(slr.btnModOk).on('click', function() {
            rm.dirtyforms.cleanForm("#formCAPassphrase");  
            window.location.href='ca-landing.html';
        });

    });
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('ca-my-details')) return;

    rm.domReady.done(function() {
        var slr = {
            ajaxLoader: '.ajax-wait',
            btnViewPass: '#viewPassphrase',
            btnPassCancel: '#passphraseCancel',
            btnEmailCancel: '#cancel',
            sectPassphrase: '#passphraseUpdate',
            email: '#emailaddress',
            pass: '#passphrase',
            sectPDetails: '.section--personal-details',
            alertErr: '.error--system-error',
            errMsg: '.error--system-error .alert__message',
            frmPass: '#formCAPassphrase',
            frmEmail: '#formCAEmail',
            passphrase: 'input[name="passphrase"]',
            modEmail: '#modalEmailSuccess',
            modPassphrase: '#modalPassphraseSuccess',
            btnModEmailOk: '#modalEmailSuccess .btn--primary',
            btnModPassOk: '#modalPassphraseSuccess .btn--primary'
        };

        $(slr.btnPassCancel).on('click', function() {
            $(slr.btnViewPass)
                .removeAttr('disabled')
                .html($(slr.btnViewPass).data('click-show-text'));
            $(slr.sectPassphrase).collapse('hide');
        });

        $(slr.btnViewPass).on('click', function() {
            if ($(this).attr('aria-expanded') === 'false') {
                $(slr.email).attr('disabled', 'disable');
            } else {
                $(slr.email).removeAttr('disabled');
            }
        });

        $(slr.btnEmailCancel).on('click', function() {
            $(slr.btnViewPass).removeAttr('disabled')
        });

        $(slr.email).on('focus', function() {
            $(slr.btnViewPass).attr('disabled', 'disable');
        });

        var caMyDetailsData = rm.ajaxData.create(),
            jsonToAttrMap = [{
                    jsonPropName: 'name'
                },
                {
                    jsonPropName: 'emailId'
                },
                {
                    jsonPropName: 'agencyName'
                },
                {
                    jsonPropName: 'agencyJurisdiction'
                },
                {
                    jsonPropName: 'ABN'
                },
                {
                    jsonPropName: 'systemIdentifier'
                },
                {
                    jsonPropName: 'passphrase',
                    targetAttr: 'value'
                }
            ];

        function loadData() {
            caMyDetailsData.init('/ncp/getCarerDetails/carer-details-data.json', jsonToAttrMap)
                .fail(function(err) {
                    console.log(err);
                })
                .done(function(respData) {
                    switch (respData.responseCode) {
                        case 'FAILED_TECH':
                            break;
                        case 'FAILED':
                            $(slr.ajaxLoader).addClass('hidden');
                            $(slr.errMsg).html(respData.errorMessage);
                            $(slr.alertErr).removeClass('hidden');
                            break;
                        case 'SUCCESS':
                            $(slr.ajaxLoader).addClass('hidden');
                            $(slr.sectPDetails).removeClass('hidden');
                            $(slr.alertErr).addClass('hidden');
                            break;
                    }
                });

        }

        loadData();

        // Save passphase
        $(slr.frmPass).on('success.form.fv', function(e) {
            e.preventDefault();            
            var pass = $(slr.passphrase).val();
            var encodedPassphrase = encodeURIComponent(pass);

                $.ajax({
                    method: 'POST',
                    url: '/ncp/updateCarerDetails',
                    data: 'passphrase=' + encodedPassphrase,
                    beforeSend: function() {
                        console.log("before fire");
                    },
                    dataType: "text",
                    success: function(response) {
                        var result = jQuery.parseJSON(response);
                        if (result.responseCode === 'PCEHR_SUCCESS') {
                            $(slr.alertErr).addClass('hidden');
                            $(slr.modPassphrase).modal('show');
                        } else {
                            $(slr.errMsg).html(result.errorMessage);
                            $(slr.alertErr).removeClass('hidden');
                        }
                    },
                    error:function(e){
                        console.log(e);
                    },
                    complete:function(){
                        $(slr.alertErr).addClass('hidden');
                        $(slr.modPassphrase).modal('show');
                    }

                });

        });

        // Save Email address
        $(slr.frmEmail).on('success.form.fv', function(e) {
            e.preventDefault();            
            var emailAddress = $(slr.email).val();
            var encodedEmail = encodeURIComponent(emailAddress);
            $("#save").attr('disabled', 'disable');
            $.ajax({
                type: 'POST',
                url: '/ncp/updateCarerDetails',
                data: 'emailId=' + encodedEmail,
                dataType: "text",
                beforeSend: function() {
                    },
                success: function(response) {
                    var result = jQuery.parseJSON(response);
                    if (result.responseCode === 'PCEHR_SUCCESS') {
                        $(slr.alertErr).addClass('hidden');
                        $(slr.modEmail).modal('show');
                    } else {
                        $(slr.errMsg).html(result.errorMessage);
                        $(slr.alertErr).removeClass('hidden');
                    }
                },
                error:function(e){
                    console.log(e);
                },
                complete:function(){
                    $(slr.alertErr).addClass('hidden');
                    $(slr.modEmail).modal('show');
                }

            });
        });


        // Modal for passphrase updated
        $(slr.btnModPassOk).on('click', function() {
            loadData();
        });

        // Modal for Email updated
        $(slr.btnModEmailOk).on('click', function() {
            loadData();
        });

    });
})();
// Admin Search page JS
(function(){
 'use strict';

 rm.domReady.done(function () {     
    if(!(rm.globals.DOM.body.hasClass('admin-search'))) return;   
        var selector = {
            header_class             : '.header__logos',           
            admin_option             : '.admin-option-select',        
            search_form              : '.search-form-container',   
            care_agency              : '.search-care-employee-container',
            select_identifier_type   : '.select-identifier-type',        
            search_person_content    : '.searchPerson-identifier-container',
            search_mhr_content       : '.searchMHR-identifier-container',           
            confirm_under_age_button : '.confirm-under-age-button',
            display_on_select        : '.js-display-onselect-block',
            opt_out                  : '.admin-opt-out-container',
            other_reason_select      : '#opt-out-reason',
            other_reason_container   : '.other-reason-container',
            cancel_registration      : '.admin-cancel-registration-container'
        };

        //Removing the anchor tag link so the user is not able to navigate to landing page when click on header logo
        $(selector.header_class).find('a').attr('href','javascript:void(0)'); 
        
        $(selector.other_reason_select).on('change',function(e) {
            e.stopPropagation();
            var otherreason = $('#opt-out-reason').val();
            if ( otherreason  == "7") {
                $(selector.other_reason_container).removeClass("hidden");
            } else {
                $(selector.other_reason_container).addClass("hidden");
            }            
        });

        /*Remove the regenerate Ivc menu item on this page. 
        This scenario is handled in AEM using sightly component, so we can remove this code of line from AEM js.*/
        $("#adminRegenerateIvcMenu").remove();

        //On change of Admin select dropdown, setting the value in session and displaying the respective forms to search
        $(selector.admin_option).on('change',function(e){  
            e.stopPropagation();      
            var admin_select_option = $(this).val(); 
            rm.sessionStorage.removeSession('adminSelectOption');         
            rm.sessionStorage.setSession('adminSelectOption',admin_select_option);        
            if(admin_select_option === 'searchIdentity' || admin_select_option === 'viewIdentityRecordStatus'){
                $(selector.search_form).removeClass("hidden");
                $(selector.select_identifier_type).removeClass("hidden");
                $(selector.search_person_content).removeClass("hidden");
                $(selector.search_mhr_content).addClass("hidden");
                $(selector.display_on_select).addClass("hidden");      
                $(selector.care_agency).addClass("hidden");
                $(selector.opt_out).addClass("hidden");
                $(selector.other_reason_container).addClass("hidden");   
                $(selector.cancel_registration).addClass("hidden");  
            }
            else if(admin_select_option === 'searchCareEmployee'){
                $(selector.search_form).addClass("hidden");
                $(selector.select_identifier_type).addClass("hidden");
                $(selector.search_person_content).addClass("hidden");
                $(selector.search_mhr_content).addClass("hidden");
                $(selector.display_on_select).addClass("hidden");                     
                $(selector.opt_out).addClass("hidden");
                $(selector.other_reason_container).addClass("hidden");
                $(selector.cancel_registration).addClass("hidden");
                $(selector.care_agency).removeClass("hidden");                
            }
            else if (admin_select_option === 'optout') {
                $(selector.search_form).addClass("hidden");
                $(selector.select_identifier_type).addClass("hidden");
                $(selector.search_person_content).addClass("hidden");
                $(selector.search_mhr_content).addClass("hidden");
                $(selector.display_on_select).addClass("hidden");      
                $(selector.care_agency).addClass("hidden");
                $(selector.cancel_registration).addClass("hidden");
                $(selector.opt_out).removeClass("hidden");
            }      
            else if (admin_select_option === 'cancelRegistration') {
                $(selector.search_form).addClass("hidden");
                $(selector.select_identifier_type).addClass("hidden");
                $(selector.search_person_content).addClass("hidden");
                $(selector.search_mhr_content).addClass("hidden");
                $(selector.display_on_select).addClass("hidden");      
                $(selector.care_agency).addClass("hidden");
                $(selector.opt_out).addClass("hidden");
                $(selector.cancel_registration).removeClass("hidden");
            }          
            else if (admin_select_option === 'restrictRecordAccess' || admin_select_option === 'searchMhr') {
                $(selector.search_form).removeClass("hidden");
                $(selector.search_mhr_content).removeClass("hidden"); 
                $(selector.select_identifier_type).addClass("hidden");
                $(selector.search_person_content).addClass("hidden");  
                $(selector.care_agency).addClass("hidden");
                $(selector.opt_out).addClass("hidden");
                $(selector.other_reason_container).addClass("hidden");
                $(selector.cancel_registration).addClass("hidden");                                           
            } else {
                $(selector.search_form).addClass("hidden");
                $(selector.search_mhr_content).removeClass("hidden"); 
                $(selector.select_identifier_type).addClass("hidden");
                $(selector.search_person_content).addClass("hidden");  
                $(selector.care_agency).addClass("hidden");
                $(selector.opt_out).addClass("hidden");
                $(selector.other_reason_container).addClass("hidden");
                $(selector.cancel_registration).addClass("hidden");                                                  
            }    

            resetForm();
        });
        
        // On submit of Search person form
        $("#formAdminSearchPerson").on('success.form.fv', function(e){
            e.preventDefault();            
            var personSearchName = $('#family-name').val();  
            var ageDiff = moment().diff(moment($('#dateofbirth-day').val()+'-'+$('#dateofbirth-month').val()+'-'+$('#dateofbirth-year').val(), 'DD-MMM-YYYY').format('MM/DD/YYYY'),'years');                                              
            var searchOption = rm.sessionStorage.getSession('adminSelectOption');            
            var errorFlag = $("#formAdminSearchPerson").find("div.form-group").hasClass("has-error"); 
            var adminUserType = $("#adminUserType").val();                      
            var ajaxSearch = rm.ajaxData.create();
            var formArray = $('#formAdminSearchPerson').serializeArray();            
            var formData={};
            formArray.forEach(function(item, index){
                formData[item.name] = item.value;
                return formData;
            });         
            if(!errorFlag){
                ajaxSearch.fetchJson('js/data/person-records.json')
                .fail(function (err) {
                    $("#server-error").removeClass('hidden');
                    $("#server-error .alert__message__content").html(err.text); 
                })
                .done(function(respData) {                    
                    var recordsData = respData.records;
                    if(recordsData.length >=1){
                        var recordDetails =  recordsData.filter(function(item, index){
                            if(personSearchName === item.familyName){
                                return item;                           
                            }
                        });
                    }
                    rm.sessionStorage.removeSession('adminType'); 
                    rm.sessionStorage.removeSession('noRecordPresent');
                    rm.sessionStorage.removeSession('isRecordRestrictionApplied');                    
                    rm.sessionStorage.setSession('adminType',adminUserType);
                    $("#server-error").addClass('hidden'); 

                    if(searchOption === 'searchIdentity'){
                        if(recordDetails[0].recordStatus === 'Verified'){ 
                            rm.dirtyforms.cleanForm("#formAdminSearchPerson");                      
                            window.location.href='admin-verify-identity.html';
                        }
                        else if(recordDetails[0].recordStatus === 'Unverified'){
                            if((ageDiff > 14 && ageDiff < 18  && adminUserType === 'T12') || (ageDiff < 18  && adminUserType === 'T3')){
                                $("#modalUnderAgeChildConfirm").modal();
                            } 
                            else if(ageDiff < 14  && adminUserType === 'T12'){
                                $("#modalUnderAgeChildWarning").modal();
                            }         
                            else{
                                rm.dirtyforms.cleanForm("#formAdminSearchPerson");
                                window.location.href='admin-unverified-identity.html';
                            }  
                        }
                        else {
                            rm.dirtyforms.cleanForm("#formAdminSearchPerson");
                            window.location.href='landing.html';
                        }    
                    }                                    
                    else if(recordDetails[0].recordStatus === 'Suspended' && adminUserType === 'T3'){                       
                        $("#modalRecordSuspended").modal();                                         
                    }                      
                    else if(recordDetails[0].recordStatus === 'No record' && adminUserType === 'T3'){                        
                        if(searchOption === 'restrictRecordAccess'){
                            rm.sessionStorage.setSession('noRecordPresent','Y');
                            window.location.href='admin-restrict-record.html';
                        }
                        else {
                            $("#server-error").removeClass('hidden');
                            $("#server-error .alert__message__content").html('Record does not exist.');
                        }                                                                                                                                                                                                                                                   
                    }                                                          
                    else if((recordDetails[0].recordStatus === 'Active' || recordDetails[0].recordStatus === 'Inactive') && searchOption === 'searchMhr'){                         
                        window.location.href='setup-myrecord.html';
                    }
                    else if(recordDetails[0].recordStatus === 'Active' && searchOption === 'restrictRecordAccess'){                        
                        rm.sessionStorage.setSession('isRecordRestrictionApplied','Y');                    
                        window.location.href='privacy-access.html';
                    }                
                    else if(recordDetails[0].recordStatus === 'Inactive' && searchOption === 'restrictRecordAccess'){                        
                        window.location.href='admin-restrict-record.html';
                    }
                    else{                        
                        window.location.href='admin-restrict-record.html';
                    }                    
                });                
            }               
        });

        // On submit of Search care agency employee form
        $('#formAdminSearchCareAgencyEmployee').on('success.form.fv', function(e) {
            e.preventDefault();
            var emailAddress = $('#emailAddress').val();            
            $.ajax({
                type: 'POST',
                url: '/ncp/searchCareAgencyEmployee',
                data: 'emailId=' + encodeURIComponent(emailAddress),
                dataType: "text",
                beforeSend: function() {
                    },
                success: function(response) {                    
                    if (responseCode === 'PCEHR_SUCCESS') {
                        rm.dirtyforms.cleanForm("#formAdminSearchCareAgencyEmployee");       
                        window.location.href='ca-verify-identity.html';
                    } else {
                       // error code goes here
                    }
                },
                error:function(e){
                    console.log(e);
                },
                //while integrating AEM , this function is not required for ajax call.
                complete:function(){
                    rm.dirtyforms.cleanForm("#formAdminSearchCareAgencyEmployee");  
                    window.location.href='ca-verify-identity.html'; 
                }
            });
        });

         //On click of confirm button - under 18 popup window
        $(selector.confirm_under_age_button).on("click",function(e){ 
            rm.dirtyforms.cleanForm("#formAdminSearchPerson");       
            window.location.href='admin-unverified-identity.html';
        });

        $('#admin-opt-out-clear').on('click',function(){                
            $('.other-reason-container').addClass('hidden');        
        });

        function resetForm(){
            $('form').each(function() { 
                this.reset(); 
            });
            $('#formAdminSearchPerson').data('formValidation').resetForm();
            $('#formAdminSearchCareAgencyEmployee').data('formValidation').resetForm();
            $('#admin-opt-out-form').data('formValidation').resetForm();
            $("#server-error").addClass('hidden');            
        }        
    });
})();
// Admin Verify page JS
(function(){
 'use strict';

 rm.domReady.done(function () {
    if(!(rm.globals.DOM.body.hasClass('admin-verify-identity') || rm.globals.DOM.body.hasClass('admin-unverified-identity'))) return;   
        var selector = {
            header_class             : '.header__logos',                                                                                        
            continue_ivc_button      : '#ivc-continue-btn',
            print_ivc_button         : '#ivc-print-btn',
            ulc_check                : '#ulc-check',
            under_age_check          : '#under-age-check'   
        };   

        var formULC   = '#consumeULCForm',
            $formULC  = $(formULC);   
        
        // Removing the anchor tag link so the user is not able to navigate to landing page when click on header logo
        $(selector.header_class).find('a').attr('href','javascript:void(0)');        

        // On click of continue button - Regenerate IVC popup window
        $(selector.continue_ivc_button).on("click", function(){
            rm.dirtyforms.cleanForm("#formAdminUnverifiedIdentity");
            window.location.href='landing.html';
        });

        $("#formAdminUnverifiedIdentity").on('success.form.fv',function(e){
            e.preventDefault();            
            //webservice call;
        });

        // On click of print button - Regenerate IVC popup window 
        $(selector.print_ivc_button).on("click", function(){
            var $this = $(this);
            var selector = $("#modalConfirmVerifyIdentity").find('.modal-header,.modal-body');
            var htmls = $(selector).map(function(index,item){
                return $('<div/>').append($(item).clone()).html();
            });
            var html = Array.prototype.slice.call(htmls).join("");
            var printWin = window.open('','','left=50,top=0,width=1200,height=600,toolbar=0,scrollbars=0,status=0');
            printWin.document.write(html);
            printWin.document.close();
            printWin.focus();
            printWin.print();
            printWin.close();
        });

        // Show Consume ULC popup if no error
        $('#formAdminUnverifiedIdentityULC').on('success.form.fv', function(e) {

            // Show consume ULC modal if ULC and Under age checkboxes are checked
            if( $(selector.ulc_check).is(':checked') && $(selector.under_age_check).is(':checked') ){
                $('#modalConsumeULC').appendTo('body').modal('show');

                /* Clear form elements within the target */
                $formULC.find('input[name="ulc"]').val('');
                $formULC.find('input[name="dob-ulc"]').val('');

                // Set form clean
                $formULC.find('.has-error').removeClass('has-error');
                $formULC.find('.icon--error').removeClass('icon--error');
                $formULC.find('.help-block').hide();
                $formULC.dirtyForms('setClean');
            }
            
            e.preventDefault();
        });             
    }); 
})();
// Admin Restrict Record page JS
(function(){
 'use strict';

 rm.domReady.done(function () {     
    if(!(rm.globals.DOM.body.hasClass('admin-restrict-record'))) return;   
        var isRecordRestrictionApplied ='Y';// rm.sessionStorage.getSession('isRecordRestrictionApplied');  
        var noRecordPresent = rm.sessionStorage.getSession('noRecordPresent');        
        var restrictionDetails = {            
            expiryDate : moment('25/09/2017', 'DD/MM/YYYY').format("DD-MMM-YYYY"),
            jiraReference :"3"
        }
        //Check if no record present then remove the navigation menu from header.
        if(noRecordPresent === 'Y'){
            $('nav.navigation').remove();
        }    
        //check if restriction is applied then get the data from response and hide/show the buttons
        if(isRecordRestrictionApplied === 'Y'){
            $('.apply-restriction-btn').remove();
            $('.update-restriction-btn').removeClass('hidden');  
            $('#restrictionExpiryDate').val(restrictionDetails.expiryDate);            
			$("#referenceNumber").val(restrictionDetails.jiraReference);  
            $("#formAdminRestrictRecordAccess").dirtyForms('rescan');        
        }
        else{           
            $('.update-restriction-btn').remove();
        }
        rm.sessionStorage.removeSession('isRecordRestrictionApplied');
        $('button.remove-restriction').on('click',function(){            
            $("#restrictionExpiryDate").val("");
            $("#referenceNumber").val("");                              
            $("#formAdminRestrictRecordAccess").dirtyForms('setClean')             
            $("#removeRecordRestriction").modal();             
        });

        $('.cancel-btn').on('click keypress', function(){
            history.go(-1); 
        });        
    });
})();
/* Page specific do not include in AEM*/
(function() {
  if($(document.body).hasClass('admin-opt-out')) {
    $('#admin-opt-out-form').on('submit', function(e) {
        $.get('/', function(res) {
          $('#modal-opt-out-error').modal();
        });
    })
  }
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('ca-proof-of-authority')) return;

    rm.domReady.done(function() {   
        var slr = {
            ARTDropdown: '#ART-dropdown',
        };

        $(slr.ARTDropdown).val('UNDER18');
        $(slr.ARTDropdown).selectpicker('refresh');
        $(slr.ARTDropdown).siblings('button').attr('disabled','disabled');

        $('form').on('submit',function(e){
            e.preventDefault();
            if( $('.has-error').length !== 0 ) return;
            var formArray = $(this).serializeArray(),
                formObj = formArray.reduce(function(acc,curr){
                    var obj = {};
                    obj[curr.name] = curr.value;
                    return acc = $.extend({},acc,obj);
                },{});
            if(formObj.endDateOfAuthority === '06-Aug-2017') {
                window.location.href = '/ca-conditional.html';
            } else {
                window.location.href = '/ca-medicare.html';

            }
        });
    });
})();
(function() {    
        'use strict';    
        if (!rm.globals.DOM.body.hasClass('ca-manage-authorised-rep-details')) return;

        rm.domReady.done(function() {        
            $('form').on('submit',function(e){
                e.preventDefault();
                if( $('.has-error').length !== 0 ) return;
                $('#modal-anchor-save').modal('show');    
            });    
        });        
})();
(function(){

  'use strict';

  rm.domReady.done(function () {
    
    /* Please do not copy this script in AEM. This is to demonstrate the cross behavior for MHRM - 402 on FED code only */
    $('#allergies-and-adverse-reactions, #current-medications').on('submit', function() {
      var formid = $(this).attr('id');
      $.get('/', { 'formid' : $(this).attr('id') }, function(data) {
        if((formid === 'allergies-and-adverse-reactions' && rm.sessionStorage.getSession('SessionRedirectSource') === 'allergy-link') || (formid === 'current-medications' && rm.sessionStorage.getSession('SessionRedirectSource') === 'meds-preview-link') ) {
          rm.sessionRedirect.trigger();
        } else {
          rm.sessionRedirect.clear();
        }
      });
    });
    /* Please do not copy this script in AEM. This is to demonstrate the cross behavior for MHRM - 402 on FED code only */
  });
  
})();
(function(){
    'use strict';
    
    rm.domReady.done(function () {
        if(!(rm.globals.DOM.body.hasClass('admin-manage-authorised'))) return; // remove this line while integrating AEM
          
        var formAction = '';
        $("#submit-btn").on('click', function(){
            formAction = 'Submit';
        });

        $("#remove-access-btn").on('click', function(){
            formAction = 'Remove';
        });

        $("#relationshipType").on('change',function(e){ 
            var endDate = $("#endDateOfAuthority").val();
            if(endDate !== ''){
                $("#formAdminManageAR").formValidation('revalidateField', $("#endDateOfAuthority"));
            }
        });

        $("#formAdminManageAR").on('success.form.fv',function(e){
            e.preventDefault();
            var webServiceFailureMsg = "We are currently experiencing an intermittent problem in displaying this page. If you are seeing this message, please retry saving the details again.";
            rm.ajaxLoader.showAjaxLoader("Loading, please wait...");
            var formArray = $("#formAdminManageAR").serializeArray();
            var formData = {};
            formArray.forEach(function(item, index) {
                formData[item.name]=item.value;
                return formData;   
            });
            
            if(formAction == 'Submit'){
                // AJAX call
                $.ajax({
                    url : "/ncp/saveManageAccessDetail",    //dummy URL
                    type : "POST",
                    cache : false,
                    dataType : "json",
                    data : JSON.stringify(formData),
                    success : function(response){
                        rm.dirtyforms.cleanForm("#formAdminManageAR");                       
                        rm.ajaxLoader.hideAjaxLoader();
                        if(respose.code == 'success'){
                            //when response is success
                            window.location.href = 'privacy-access.html';
                        }
                        else{
                            //when response is other than success
                            displayFormErrorMessage(response.responseText);
                        }
                    },
                    error : function(xhr){
                        rm.ajaxLoader.hideAjaxLoader();
                        displayServerErrorMessage(webServiceFailureMsg);
                    }
                });
            }
            else{
                // AJAX call
                $.ajax({
                    url : "/ncp/removeManageAccessDetail",  //dummy URL
                    type : "POST",
                    cache : false,
                    dataType : "json",
                    data : JSON.stringify(formData),
                    success : function(response){
                        rm.dirtyforms.cleanForm("#formAdminManageAR");                       
                        rm.ajaxLoader.hideAjaxLoader();
                        if(respose.code == 'success'){
                            //when response is success
                            $("#modal-remove-access").modal();
                        }
                        else{
                            //when response is other than success
                            displayFormErrorMessage(response.responseText);
                        }
                    },
                    error : function(xhr){
                        rm.ajaxLoader.hideAjaxLoader();
                        displayServerErrorMessage(webServiceFailureMsg);
                    }
                });
            }
        });

        function displayServerErrorMessage(errMsg) {
            $("#server-error").removeClass('hidden');
            $("#server-error .alert__message__content").html(errMsg);
            $('html,body').animate({scrollTop : 0});
        }
        
        function displayFormErrorMessage(errMsg) {
            $("#form-error").removeClass('hidden');
            $("#form-error .alert__message__content").html(errMsg);
        }
    });   
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('ca-restriction-in-place')) return;

    rm.domReady.done(function() {
        var slr = {
            form:'#formAdminRestrictRecordAccess',
            applyRecordRestriction: '#applyRecordRestriction',
            removeRecordRestriction:'#removeRecordRestriction',
            applyRecordRestrictionBtnModOk: '#applyRecordRestriction .btn--primary',
            removeRecordRestrictionBtnModOk: '#removeRecordRestriction .btn--primary'
        };

       /* $('#remove-restriction-btn').on('click',function(){
            $(slr.removeRecordRestriction).modal('show');
        });

        $('#update-restriction-btn').on('click',function(){
            $(slr.applyRecordRestriction).modal('show');
        });*/

        $(slr.form).on('success.form.fv', function(e) {
            e.preventDefault();
            $(slr.applyRecordRestriction).modal('show');
        });

        // Modal for update passphrase
        $(slr.removeRecordRestrictionBtnModOk + ',' + slr.applyRecordRestrictionBtnModOk).on('click', function() {
            rm.dirtyforms.cleanForm(slr.form);
            window.location.href='ca-landing.html';
        });

    });
})();
(function(){

  'use strict';


  rm.domReady.done(function () {
  if (!rm.globals.DOM.body.hasClass('cic-transfer-of-authority')) return;
    var slr = {
          showEmty: '.display--emptytable',
          showFill: '.display--filledtable',
          sysErr: '.error--system-error',
          sysErrText: '.error--system-error .alert__message__content',
          tb: '#ca-linked-records',
          tbEmpty: '#ca-linked-records--empty',
          lastLog: '.last-logged-in span',
          noRecords: '.no-linked-records',
          msg_content: 'p.alert__content',
        },
        cls = {
          hide: 'hidden'
        },
        txt = {
          lastLog: 'You last logged in on '
        },
        countchecked = 0,
        selectedcheckedval
        
        $(slr.showFill).addClass(cls.hide);
        rm.ajaxLoader.showAjaxLoader("Loading, please wait...");
    var caRecordAjaxTb = rm.ajaxTb.create(),
        jsonToAttrMap = [
          {
            jsonPropName: 'ihi',
            targetElem: false,
            targetAttr: 'data-ihi'
          },
          {
            jsonPropName: 'recordID',
            targetElem: false,
            targetAttr: 'data-recordid'
          },
          {
            jsonPropName: 'transferStatus',
            targetElem: false,
            targetAttr: 'data-transferstatus'
          },
          {
            jsonPropName: 'name',
            targetElem: 'td:nth-child(1) span span',
            targetAttr: false
          },
          {
            jsonPropName: 'name',
            targetElem: 'td:nth-child(2) span',
            targetAttr: false
          },
          {
            jsonPropName: 'name',
            targetElem: 'td:nth-child(2)',
            targetAttr: 'data-search'
          },
          {
            jsonPropName: 'dob',
            targetElem: 'td:nth-child(3) span',
            targetAttr: false
          },
          {
            jsonPropName: 'dobTime',
            targetElem: 'td:nth-child(3)',
            targetAttr: 'data-order'
          },
          {
            jsonPropName: 'age',
            targetElem: 'td:nth-child(4) span',
            targetAttr: false
          },
          {
            jsonPropName: 'ageMonth',
            targetElem: 'td:nth-child(4)',
            targetAttr: 'data-order'
          },
          {
            jsonPropName: 'sex',
            targetElem: 'td:nth-child(5) span',
            targetAttr: false
          },
          {
            jsonPropName: 'ihi',
            targetElem: 'td:nth-child(6) span',
            targetAttr: false
          },
          {
            jsonPropName: 'recordStatus',
            targetElem: false,
            targetAttr: 'data-status'
          },
          {
            jsonPropName: 'transferStatus',
            targetElem: 'td:nth-child(7) .status',
            targetAttr: false
          },
          {
            jsonPropName: 'transferName',
            targetElem: 'td:nth-child(7) .transfer-name-block .transfer-name span',
            targetAttr: false
          },
          {
            jsonPropName: 'ihi',
            targetElem: 'td:nth-child(1) input',
            targetAttr: 'id'
          },
          {
            jsonPropName: 'ihi',
            targetElem: 'td:nth-child(1) label',
            targetAttr: 'for'
          },
           {
            jsonPropName: 'recordID',
            targetElem: 'td:nth-child(1) input',
            targetAttr: 'value'
          },
        ];

    // setting table page length for mobile view
    if($(window).width() <= 767){
      $("#cic-transfer-authority-records").attr("data-page-length",'5');
    }

    var jsonDataDummy = './ncp/checkCarerIdentity/table-form_ca-records-transfer-data.json';

    caRecordAjaxTb.init('#cic-transfer-authority-records', jsonDataDummy, jsonToAttrMap)
    .fail(function (err) {
        console.log(err);
        rm.ajaxLoader.hideAjaxLoader();
      })
    .done(function(respData) {
        if (!caRecordAjaxTb.state.jsonData) {
          //Empty table
          $(slr.showEmty).removeClass(cls.hide);
          $(slr.showFill).addClass(cls.hide);
          switch (respData.errorCode) {
            case 'FAILED_TECH':
              $(slr.sysErrText).html(respData.errorMessage);
              $(slr.sysErr).removeClass(cls.hide);
              $(slr.tb).addClass(cls.hide);
              $(slr.tbEmpty).addClass(cls.hide);
              rm.ajaxLoader.hideAjaxLoader();
              break;
            case 'FAILED':
              $(slr.tbEmpty).addClass(cls.hide);
              $(slr.msg_content).html(respData.errorMessage)
              $(slr.noRecords).removeClass(cls.hide);
              rm.ajaxLoader.hideAjaxLoader();
              break;
          }
        } else {
          $(slr.showEmty).addClass(cls.hide);
          $(slr.showFill).removeClass(cls.hide);
          disableSuspendedRecord();
          rm.ajaxLoader.hideAjaxLoader();
        }

        $(slr.lastLog).html(txt.lastLog + respData.lastUpdated);
        var $tb = $('#cic-transfer-authority-records');
        rm.table.initDataTable($tb);
        rm.tbMobileSort.init({
          wrap: '.js-m-datatable-sort--custom',
          th: '#cic-transfer-authority-records thead th'
        });
        rm.tbSearch.init($tb);

  
        });

        function disableSuspendedRecord(){
          var $tr = $(slr.tb).find('tbody > tr')
          $tr.each(function(ind,$item){
            var status = $($item).data('status');
            if(status === 'Suspended'){
              $($item).attr('disabled','disabled');
            }
          });
        }

        $('#cic-transfer-authority-records').on('page.dt, draw.dt', function () {
          $("#cic-transfer-authority-records_paginate").find('a').addClass('internal-link');
          $("#select-all-child").removeClass('selected').text('Select All');
          countCheckbox();
          
           $('#cic-transfer-authority-records input[name="transfer-authority"]').on('click keypress', function(e){
              if ($(this).is(":checked") === false) {
                $('#transfer-authority-checkbox').prop('checked', false);
              }
              countCheckbox();
          });

        });

  });
})();

function selectAllChild(el) {
  var $checkboxes = $('.transfer-auth');

      $(el).toggleClass('selected');

      if ($(el).hasClass('selected')) {
          $(el).text('Deselect All');
          var table = $("#cic-transfer-authority-records").DataTable();
          var countchecked = table
                    .rows()
                    .nodes()
                    .to$()      // Convert to a jQuery object
                    .find('input[name="transfer-authority"]:checked').length;

          var trcount = $("#cic-transfer-authority-records > tbody > tr input:checkbox:not(:checked)").length;

          if(countchecked < 20) {
              var remaining = (20 - countchecked);
              if (trcount > remaining) {
                 $("#cic-transfer-authority-records > tbody > tr input:checkbox:not(:checked)")
                  .slice(0, remaining).prop('checked', true);
              } else {
                   $checkboxes.prop('checked', true);
              }
          }
          
          $('#form-cic-transfer-of-authority').dirtyForms('rescan');
          $('.select-checbox-error').addClass('hidden');
      } else {
          $(el).text('Select All');
          var dataTable = $("#cic-transfer-authority-records").DataTable();
          dataTable.rows().nodes().to$().find('.transfer-auth').prop('checked', false);
          $('#form-cic-transfer-of-authority').dirtyForms('setClean');
      }
      
      countCheckbox();
}

function countCheckbox() {
  var table = $("#cic-transfer-authority-records").DataTable();

  countchecked = table
                    .rows()
                    .nodes()
                    .to$()      // Convert to a jQuery object
                    .find('input[name="transfer-authority"]:checked').length;
  var checkeddata = table.rows().nodes().to$().find('input[name="transfer-authority"]:checked');
  selectedcheckedval = [];

  checkeddata.each(function(index, item){
    selectedcheckedval.push({
      ihi: $(item).attr('id'),
      recordID: $(item).attr('value')
    });
  });


  if (countchecked >= 20) {
    $("#cic-transfer-authority-records input:checkbox:not(:checked)").prop('disabled', true);
    $('#record-selected').html('<strong>The maximum number of 20 records has been selected. Please select Continue.</strong>');
    $("html, body").animate({ scrollTop: $(document).height() }); // scroll to the bottom
  } else {
    $("#cic-transfer-authority-records input:checkbox:not(:checked)").prop('disabled', false);
    $('#record-selected').html('<strong>Records Selected: '+countchecked+'</strong>');
    $('#transfer-authority-checkbox').prop('checked', false);
    $('.select-checbox-error').addClass('hidden');
  }
}

// submit, if no error
$('#form-cic-transfer-of-authority').on('success.form.fv', function(e) {

    e.preventDefault();

    // Needs to change in AEM
    // variable selectedcheckedval is where the ihi and recordID values of the selected checkboxes
    if(countchecked > 0 ) {
      window.location.href='/cic-transfer-of-authority-confirmation.html';
    } else {
      $('.select-checbox-error').removeClass('hidden');
       $("html, body").animate({ scrollTop: 0 }); // scroll to the bottom
    }

});
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('cic-existing-restriction-details')) return;

    rm.domReady.done(function() {
        var slr = {
            form:'#formAdminRestrictRecordAccess',
            removeRecordRestriction: '#removeRecordRestriction',
            confirmRecordRestriction:'#confirmRecordRestriction',
            removeRecordRestrictionBtnModOk: '#removeRecordRestriction .btn--primary',
            confirmRecordRestrictionBtnModOk: '#confirmRecordRestriction .btn--primary'
        };

        /*$('#remove-restriction-btn').on('click',function(){
            $(slr.removeRecordRestriction).modal('show');
        });

        $('#confirm-restriction-btn').on('click', function() {
          $(slr.confirmRecordRestriction).modal('show');
        });*/


        $(slr.form).on('success.form.fv', function(e) {
            e.preventDefault();
            $(slr.confirmRecordRestriction).modal('show');
        });

        // Modal for update passphrase
        $(slr.removeRecordRestrictionBtnModOk + ', ' + slr.confirmRecordRestrictionBtnModOk).on('click', function() {
            rm.dirtyforms.cleanForm(slr.form);
            window.location.href='ca-landing.html';
        });

    });
})();
(function(){

  'use strict';

  rm.domReady.done(function () {
    var option1         =  '.radio-questions-1',    
        option2         =  '.radio-questions-2',
        option3         =  '.radio-questions-3',     
        option4         =  '.radio-questions-4',    
        $template1      =  $('.template1'),
        $template2      =  $('.template2'),
        pastWrapper     =  null,
        nextOption      =  null,
        that            =  null,
        futureOptions   =  [option1, option3].join(', ');

      $(futureOptions).on('click', function(){
        that = $(this);
        nextOption = (that[0].className.split(' ')[0] === option1.substring(1)) ? option2 : option4;
        pastWrapper = that.parentsUntil('.radio-questions').parent().next();
        if( (that.val() === "no" && $('input'+nextOption+':checked').val() === "no") || (that.val() === "no" && typeof $('input'+nextOption+':checked').val() === "undefined") ){
          pastWrapper.addClass('hidden');
        }else if(that.val() === "yes" && typeof $('input'+nextOption+':checked').val() === "undefined"){
          that.parentsUntil('.form-section').next().find('legend').parent().find('p').remove();
          pastWrapper.removeClass('hidden');
          that.parentsUntil('.form-section').next().find('legend').after($template1.removeClass('hidden').clone());
        }else if(that.val() === "yes" && $('input'+nextOption+':checked').val() === "yes"){
          that.parentsUntil('.form-section').next().find('legend').parent().find('p').remove();
          pastWrapper.removeClass('hidden');
          that.parentsUntil('.form-section').next().find('legend').after($template2.removeClass('hidden').clone());
        }
      });
  });
})();
(function(){

  'use strict';

  rm.domReady.done(function () {
    if(rm.globals.DOM.body.hasClass('medicareoverview')) {
      var todayDate= moment().format('DD/MM/YYYY');
      var arrCurrentDate = todayDate.split('/');
      var toDate = moment().year((arrCurrentDate[2] - 2)).format('DD/MM/YYYY');
      var arrToDate = toDate.split('/');

      // Set default value Date From
      $('#date-from-day').val(arrToDate[0]);
      $('#date-from-month').val(arrToDate[1]);
      $('#date-from-year').val(arrToDate[2]);

      // Set default value Date To
      $('#date-to-day').val(arrCurrentDate[0]);
      $('#date-to-month').val(arrCurrentDate[1]);
      $('#date-to-year').val(arrCurrentDate[2]);
    }
  });
  
})();
"use strict";

var _extends =
  Object.assign ||
  function(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];
      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }
    return target;
  };

function _toConsumableArray(arr) {
  if (Array.isArray(arr)) {
    for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) {
      arr2[i] = arr[i];
    }
    return arr2;
  } else {
    return Array.from(arr);
  }
}

/* jshint ignore:start */

(function($, Redux) {
  if ($("body.personal-health-summary").length === 0) return;

  var createStore = Redux.createStore,
    combineReducers = Redux.combineReducers;

  // Reducers

  var AllergyTableDataReducer = function AllergyTableDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "ALLERGY_TABLE_ADD":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "ALLERGY_TABLE_UPDATE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ALLERGY_TABLE_REMOVE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ALLERGY_TABLE_INIT":
        return actions.items;
      default:
        return state;
    }
  };

  var MedicationTableDataReducer = function MedicationTableDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "MEDICATION_TABLE_ADD":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "MEDICATION_TABLE_UPDATE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "MEDICATION_TABLE_REMOVE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "MEDICATION_TABLE_INIT":
        return actions.items;
      default:
        return state;
    }
  };

  var AllergyFormReducer = function AllergyFormReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "ALLERGY_FORM_ADD_SECTION":
        return [].concat(_toConsumableArray(state), [
          { id: "", substance: "", reaction: [""] }
        ]);
      case "ALLERGY_FORM_INSERT_SECTION":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "ALLERGY_FORM_UPDATE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ALLERGY_FORM_REMOVE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ALLERGY_FORM_ADD_REACTION":
        return JSON.parse(JSON.stringify(state)).map(function(item, index) {
          if (index === actions.index) {
            item.reaction.push("");
            return item;
          }
          return item;
        });
      case "ALLERGY_FORM_UPDATE_REACTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ALLERGY_FORM_REMOVE_REACTION":
        return JSON.parse(JSON.stringify(state)).map(function(item, index) {
          if (index === actions.allergyIndex) {
            item.reaction.splice(actions.reactionIndex, 1);
            return item;
          }
          return item;
        });
      case "ALLERGY_FORM_INIT":
        return [];
      default:
        return state;
    }
  };

  var MedicationFormReducer = function MedicationFormReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "MEDICATION_FORM_ADD_SECTION":
        return [].concat(_toConsumableArray(state), [
          {
            id: "",
            medicineDescription: "",
            medicationDose: "",
            medicineReason: "",
            medicationComments: ""
          }
        ]);
      case "MEDICATION_FORM_INSERT_SECTION":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "MEDICATION_FORM_UPDATE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "MEDICATION_FORM_REMOVE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "MEDICATION_FORM_INIT":
        return [];
      default:
        return state;
    }
  };

  var AllergyModeReducer = function AllergyModeReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { mode: "" };
    var actions = arguments[1];

    switch (actions.type) {
      case "ALLERGY_ENTER_EDIT_MODE":
        return _extends({}, state, { mode: "edit" });
      case "ALLERGY_ENTER_ADD_MODE":
        return _extends({}, state, { mode: "add" });
      case "ALLERGY_ENTER_REMOVE_MODE":
        return _extends({}, state, { mode: "remove" });
      case "ALLERGY_ENTER_SAVE_MODE":
        return _extends({}, state, { mode: "save" });
      case "ALLERGY_ENTER_SAVE_REMOVE_MODE":
        return _extends({}, state, { mode: "save_remove" });
      case "ALLERGY_ENTER_CANCEL_REMOVE_MODE":
        return _extends({}, state, { mode: "cancel_remove" });
      case "ALLERGY_RESTRICT_MODE":
        return _extends({}, state, { mode: "restricted" });
      case "ALLERGY_ENTER_INIT_MODE":
        return _extends({}, state, { mode: "" });
      default:
        return state;
    }
  };

  var MedicationModeReducer = function MedicationModeReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { mode: "" };
    var actions = arguments[1];

    switch (actions.type) {
      case "MEDICATION_ENTER_EDIT_MODE":
        return _extends({}, state, { mode: "edit" });
      case "MEDICATION_ENTER_ADD_MODE":
        return _extends({}, state, { mode: "add" });
      case "MEDICATION_ENTER_REMOVE_MODE":
        return _extends({}, state, { mode: "remove" });
      case "MEDICATION_ENTER_SAVE_REMOVE_MODE":
        return _extends({}, state, { mode: "save_remove" });
      case "MEDICATION_ENTER_CANCEL_REMOVE_MODE":
        return _extends({}, state, { mode: "cancel_remove" });
      case "MEDICATION_ENTER_SAVE_MODE":
        return _extends({}, state, { mode: "save" });
      case "MEDICATION_RESTRICT_MODE":
        return _extends({}, state, { mode: "restricted" });
      case "MEDICATION_ENTER_INIT_MODE":
        return _extends({}, state, { mode: "" });
      default:
        return state;
    }
  };

  var ServerDataReducer = function ServerDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { payload: { allergiesItems: [], medicineItems: [] } };
    var actions = arguments[1];

    switch (actions.type) {
      case "FETCH_REMOTE_DATA":
        return _extends({}, state, { payload: {}, loading: true });
      case "FETCH_REMOTE_DATA_SUCCESS":
        return _extends({}, state, {
          payload: actions.payload,
          loading: false
        });
      case "FETCH_REMOTE_DATA_FAIL":
        return _extends({}, state, {
          payload: {},
          loading: false,
          error: actions.error
        });
      case "SUBMIT_DATA_TO_REMOTE":
        return _extends({}, state, {
          dataSent: actions.payload,
          submiting: true
        });
      case "SUBMIT_DATA_TO_REMOTE_SUCCESS":
        return _extends({}, state, {
          submiting: false,
          sucessReponse: actions.response
        });
      case "SUBMIT_DATA_TO_REMOTE_FAIL":
        return _extends({}, state, { submiting: false, error: actions.error });
      default:
        return state;
    }
  };

  var JRCDataReducer = function JRCDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { payload: {} };
    var actions = arguments[1];

    switch (actions.type) {
      case "FETCH_REMOTE_JCR":
        return _extends({}, state, { payload: {}, loading: true });
      case "FETCH_REMOTE_JCR_SUCCESS":
        return _extends({}, state, {
          payload: actions.payload,
          loading: false
        });
      case "FETCH_REMOTE_JCR_FAIL":
        return _extends({}, state, {
          payload: {},
          loading: false,
          error: actions.error
        });
      default:
        return state;
    }
  };

  var rootReducer = combineReducers({
    allergyTable: AllergyTableDataReducer,
    medicationTable: MedicationTableDataReducer,
    allergyForm: AllergyFormReducer,
    medicationForm: MedicationFormReducer,
    allergyMode: AllergyModeReducer,
    medicationMode: MedicationModeReducer,
    server: ServerDataReducer,
    JCR: JRCDataReducer
  });

  // store configuration

  var store = createStore(rootReducer);

  var handleChange = function handleChange() {
    var data = store.getState();
    window.GLOBAL_JCR = data.JCR.payload;
	  $(".personal-health-summary .ajax-loader").addClass("hidden");
    if (data.server.error && data.server.error !== "") {
      $("#main-content")
        .nextAll()
        .remove()
        .end()
        .after(error());
      return;
    }

    if (data.server.loading) {
      $(".ajax-loader--phs")
        .removeClass("hidden")
        .addClass("loader-active");
      $("body").addClass("fetching-data");
      return;
    } else {
      $(".ajax-loader--phs")
        .addClass("hidden")
        .removeClass("loader-active");
      $("body").removeClass("fetching-data");
    }

    if (data.allergyTable.length > 0) {
      $("#adverse-reaction-table")
        .html("")
        .append(
          renderAllergyTableContentTpl(
            data.allergyTable,
            data.allergyMode.mode,
            data.medicationMode.mode
          )
        );
    } else {
      $("#adverse-reaction-table")
        .html("")
        .append(noDataTpl())
        .append(
          data.medicationMode.mode !== "restricted"
            ? data.medicationMode.mode === ""
              ? "<p>" + GLOBAL_JCR.AARInfo + "</p>"
              : "<p>" + GLOBAL_JCR.AARNote + "</p>"
            : "<p></p>"
        );
    }

    if (data.allergyTable.length > 0 || data.medicationTable.length > 0) {
      $("#section-util").removeClass("section--no-margin");
      $(".toolbar-nav").removeClass("hidden");
    } else {
      $("#section-util").addClass("section--no-margin");
      $(".toolbar-nav").addClass("hidden");
    }

    if (data.medicationTable.length > 0) {
      $("#medication-table")
        .html("")
        .append(
          renderMedicationTableContentTpl(
            data.medicationTable,
            data.medicationMode.mode,
            data.allergyMode.mode
          )
        );
    } else {
      $("#medication-table")
        .html("")
        .prepend(noDataTpl("" + GLOBAL_JCR.noMedication, "medication-no-data"))
        .append(
          data.allergyMode.mode !== "restricted"
            ? data.allergyMode.mode === ""
              ? "<p>" + GLOBAL_JCR.medicationInfo + "</p>"
              : "<p>" + GLOBAL_JCR.medicationNote + "</p>"
            : "<p></p>"
        );
    }

    if (data.allergyForm.length > 0) {
      $("#adverse-reaction-form .table-controls")
        .html("")
        .append(
          renderAllergyForm(
            data.allergyForm,
            data.allergyMode.mode,
            data.server.submiting
          )
        );
      $("#adverse-reaction-no-data").remove();
      $('form').dirtyForms();
    } else {
      $("#adverse-reaction-form .table-controls")
        .html("")
        .append(addButton());
    }

    if (data.medicationForm.length > 0) {
      $("#medication-form .table-controls")
        .html("")
        .append(
          renderMedicationForm(
            data.medicationForm,
            data.medicationMode.mode,
            data.server.submiting
          )
        );
        $('form').dirtyForms();
      $("#medication-no-data").remove();
    } else {
      $("#medication-form .table-controls")
        .html("")
        .append(
          addButton({
            action: "add-medication",
            text: "" + GLOBAL_JCR.addMediactionButtonText
          })
        );
    }

    if (data.allergyMode.mode !== "") {
      $("#medication-form .table-controls").html("");
    }

    if (data.medicationMode.mode !== "") {
      $("#adverse-reaction-form .table-controls").html("");
    }

    if (rm.sessionStorage.getSession("isMedInfoRedirect") === "true") {
      rm.sessionStorage.removeSession("isMedInfoRedirect");
      rm.sessionRedirect.trigger();
      rm.sessionRedirect.clear();
    }
  };

  var unsubscribe = store.subscribe(handleChange);

  // templates

  var addButton = function addButton() {
    var config =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { action: "add-allergy", text: "" + GLOBAL_JCR.addAARButtonText };

    return (
      '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row action-control ShowHidePHSElem">\n              <div class="col-xs-12">\n                <button type="button" class="btn btn--primary btn-lg" data-action="' +
      config.action +
      '">\n                  ' +
      config.text +
      "\n                </button>\n              </div>\n            </div>\n          </div>\n        </div>\n    "
    );
  };

  var renderAllergyTableContentTpl = function renderAllergyTableContentTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var allergyMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var medicationMode =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : "";
    var JCR =
      arguments.length > 3 && arguments[3] !== undefined
        ? arguments[3]
        : {
            substance: "Substance or Agent",
            reaction: "Adverse Reactions (optional)"
          };
    var tableCaption =
      arguments.length > 4 && arguments[4] !== undefined
        ? arguments[4]
        : $("#adverse-reactions h2").text();

    return (
      '\n        <table class="table--base js-tb-rows-to-lists">\n          <caption class="sr-only">' +
      tableCaption +
      '</caption>\n          <thead>\n            <tr>\n              <th class="substance">' +
      GLOBAL_JCR.substanceAgentText +
      '</th>\n              <th class="reaction">' +
      JCR.reaction +
      "</th>\n              " +
      (medicationMode === ""
        ? allergyMode === "add"
          ? ""
          : '<th class="text-right action ShowHidePHSElem">Actions</th>'
        : "") +
      "\n            </tr>\n          </thead>\n          <tbody>\n            " +
      allergyTableListTpl(props, allergyMode, medicationMode, JCR) +
      '\n          </tbody>\n        </table>\n        <div class="row">\n          <div class="col-xs-12">\n        ' +
      (allergyMode !== "restricted"
        ? " \n          " +
          (medicationMode === ""
            ? "\n              " +
              (allergyMode === "add"
                ? "<p>" +
                  GLOBAL_JCR.AARInfo +
                  "</p>" +
                  getAllergyHintText(allergyMode)
                : "" +
                  (allergyMode === ""
                    ? "<p>" + GLOBAL_JCR.AARInfo + "</p>"
                    : "" + getAllergyHintText(allergyMode))) +
              "\n          "
            : "\n             <p>" + GLOBAL_JCR.AARNote + "</p>\n          ") +
          "\n          "
        : "") +
      "\n            </div>\n        </div>\n    "
    );
  };

  var renderMedicationTableContentTpl = function renderMedicationTableContentTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var medicationMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var allergyMode =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : "";
    var JCR =
      arguments.length > 3 && arguments[3] !== undefined
        ? arguments[3]
        : JSON.parse($("#medicationJRCData").val());
    var tableCaption =
      arguments.length > 4 && arguments[4] !== undefined
        ? arguments[4]
        : $("#current-medications-section h2").text();

    return (
      '\n        <table class="table--base js-tb-rows-to-lists">\n          <caption class="sr-only">' +
      tableCaption +
      '</caption>\n          <thead>\n            <tr>\n              <th class="medicine">Medicine</th>\n              <th class="dose-info">' +
      GLOBAL_JCR.dose +
      '</th>\n              <th class="reason">' +
      GLOBAL_JCR.reason +
      ' (optional)</th>\n              <th class="comment">' +
      GLOBAL_JCR.comments +
      " (optional)</th>\n              " +
      (allergyMode === ""
        ? medicationMode === "add"
          ? ""
          : '<th class="text-right action ShowHidePHSElem">Actions</th>'
        : "") +
      "\n            </tr>\n          </thead>\n          <tbody>\n            " +
      medicationTableListTpl(props, medicationMode, allergyMode, JCR) +
      '\n          </tbody>\n        </table>\n        <div class="row">\n          <div class="col-xs-12">\n        ' +
      (allergyMode !== "restricted"
        ? "\n          " +
          (allergyMode === ""
            ? "\n            " +
              (medicationMode === "add"
                ? "<p>" +
                  GLOBAL_JCR.medicationInfo +
                  "</p>" +
                  getMedicineHintText(medicationMode)
                : "" +
                  (medicationMode === ""
                    ? "<p>" + GLOBAL_JCR.medicationInfo + "</p>"
                    : "" + getAllergyHintText(medicationMode))) +
              "\n          "
            : "\n              <p>" +
              GLOBAL_JCR.medicationNote +
              "</p>\n\n          ") +
          "\n           "
        : "") +
      "\n            </div>\n        </div>\n    "
    );
  };

  var allergyTableListTpl = function allergyTableListTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var allergyMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var medicationMode =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : "";
    var JCR =
      arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};

    return props.reduce(function(acc, cur, index, arr) {
      var id = cur.id,
        substance = cur.substance,
        reaction = cur.reaction,
        status = cur.status;

      return (
        "\n            " +
        acc +
        '\n            <tr class="' +
        status +
        '">\n              <td class="substance" data-th="' +
        GLOBAL_JCR.substanceAgentText +
        '">' +
        substance +
        '</td>\n              <td class="reaction" data-th="' +
        JCR.reaction +
        '">\n              ' +
        (reaction.length > 0
          ? "\n                  <ul>\n                    <li>" +
            reaction.join("</li><li>") +
            "</li>\n                  </ul>\n                "
          : "") +
        "\n              </td>\n              " +
        allergyActionsByStatus(allergyMode, medicationMode, status, id) +
        "\n            </tr>\n        "
      );
    }, "");
  };
  var medicationTableListTpl = function medicationTableListTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var medicationMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var allergyMode =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : "";
    var JCR =
      arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};

    return props.reduce(function(acc, cur, index, arr) {
      var id = cur.id,
        medicineDescription = cur.medicineDescription,
        medicationDose = cur.medicationDose,
        medicineReason = cur.medicineReason,
        medicationComments = cur.medicationComments,
        status = cur.status;

      return (
        "\n            " +
        acc +
        '\n            <tr class="' +
        status +
        '">\n              <td class="medicine" data-th="' +
        GLOBAL_JCR.medicine +
        '">' +
        medicineDescription +
        '</td>\n              <td class="dose-info" data-th="' +
        GLOBAL_JCR.dose +
        '">' +
        medicationDose +
        '</td>\n              <td class="reason" data-th="' +
        GLOBAL_JCR.reason +
        '">' +
        medicineReason +
        '</td>\n              <td class="comment" data-th="' +
        GLOBAL_JCR.comments +
        '">' +
        medicationComments +
        "</td>\n              " +
        medicationActionsByStatus(medicationMode, allergyMode, status, id) +
        "\n            </tr>\n        "
      );
    }, "");
  };

  var allergyActionsByStatus = function allergyActionsByStatus(
    allergyMode,
    medicationMode,
    status,
    id
  ) {
    if (status === "saved") {
      if (medicationMode !== "" || allergyMode === "add") {
        return "";
      }
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              ' +
        actionsByMode(allergyMode, id) +
        "\n            </div>\n           </td>\n           "
      );
    }

    if (status === "editing") {
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-edit">Undo Edit</button>\n            </div>\n           </td>\n           '
      );
    }

    if (status === "removing") {
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-remove">Undo Remove</button>\n            </div>\n           </td>\n         '
      );
    }
    return "";
  };

  var medicationActionsByStatus = function medicationActionsByStatus(
    medicationMode,
    allergyMode,
    status,
    id
  ) {
    var $toolbarNav = $(".toolbar-nav");

    if (
      medicationMode === "add" ||
      medicationMode === "edit" ||
      medicationMode === "remove" ||
      allergyMode === "add" ||
      allergyMode === "edit" ||
      allergyMode === "remove"
    ) {
      $toolbarNav.addClass("hidden");
    } else {
      $toolbarNav.removeClass("hidden");
    }

    if (status === "saved") {
      if (allergyMode !== "" || medicationMode === "add") {
        return "";
      }
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              ' +
        actionsByMode(medicationMode, id) +
        "\n            </div>\n           </td>\n           "
      );
    }

    if (status === "editing") {
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-edit">Undo Edit</button>\n            </div>\n           </td>\n           '
      );
    }

    if (status === "removing") {
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-remove">Undo Remove</button>\n            </div>\n           </td>\n         '
      );
    }
    return "";
  };

  var actionsByMode = function actionsByMode(mode, id) {
    if (mode === "edit") {
      return (
        '\n            <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="edit">Edit</button>\n        '
      );
    }

    if (mode.indexOf("remove") !== -1) {
      return (
        '\n        <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="remove">Remove</button>\n        '
      );
    }

    return (
      '\n        <button type="button" class="btn-link internal-link" data-id="' +
      id +
      '" data-action="edit">Edit</button>\n              <button type="button" class="btn-link internal-link" data-id="' +
      id +
      '" data-action="remove">Remove</button>\n    '
    );
  };

  var spinnerTpl = function spinnerTpl() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "Saving your changes";

    return (
      '\n     <div class="ajax-loader__table">\n       <div class="loader-spinner loader-spinner__circle"></div>\n       <div class="ajax-loader__text">\n         <p>' +
      text +
      "</p>\n       </div>\n     </div>\n    "
    );
  };

  var renderAllergyForm = function renderAllergyForm() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var mode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var serverLoading = arguments[2];

    var action = getActionText(mode);

    var button =
      mode === "add"
        ? '<div class="row">\n                <div class="col-xs-12">\n                    <button type="button" class="btn-link internal-link" data-action="add-allergy">Add another allergy</button>\n                </div>\n            </div>'
        : "";

    if (mode.indexOf("remove") !== -1) {
      return (
        '\n             <form>\n                <h2 id="allergy-focus-content" tabindex="-1" class="focus-title">' +
        action +
        " Allergy and Adverse Reaction</h2>\n                <p>" +
        GLOBAL_JCR.removeAlertText +
        '</p>\n                <ul class="remove-list">\n                ' +
        renderAllergyRemoveList(props) +
        "\n                </ul>\n                " +
        submitButtonsTpl(serverLoading) +
        "\n            </form>\n        "
      );
    }

    if (mode === "save") {
      return "" + spinnerTpl();
    }

    return (
      '\n    <form class="js-validate sodirty">\n        <h2 id="allergy-focus-content" tabindex="-1" class="focus-title">' +
      action +
      ' Allergy and Adverse Reaction</h2>\n        <p>' +
      GLOBAL_JCR.errorText +
      '</p><div class="form-group">\n        ' +
      renderAllergyFormSectionList(props, mode) +
      '\n</div>        <div class="buttons-group">\n            ' +
      button +
      "\n            " +
      submitButtonsTpl(serverLoading) +
      "\n        </div>\n    </form>\n    "
    );
  };

  var renderMedicationForm = function renderMedicationForm() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var mode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var serverLoading =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

    var action = getActionText(mode);

    var button =
      mode === "add"
        ? '<div class="row">\n                <div class="col-xs-12">\n                    <button type="button" class="btn-link internal-link" data-action="add-medication">Add another medicine</button>\n                </div>\n            </div>'
        : "";

    if (mode.indexOf("remove") !== -1) {
      return (
        '\n             <form>\n                <h2 id="medication-focus-content" tabindex="-1" class="focus-title">' +
        action +
        " Medication</h2>\n                <p>" +
        GLOBAL_JCR.removeAlertText +
        '</p>\n                <ul class="remove-list">\n                ' +
        renderMedicationRemoveList(props) +
        "\n                </ul>\n                " +
        submitButtonsTpl(serverLoading) +
        "\n            </form>\n        "
      );
    }

    if (mode === "save") {
      return "" + spinnerTpl();
    }

    return (
      '\n    <form class="js-validate sodirty">\n        <h2 id="medication-focus-content" tabindex="-1" class="focus-title">' +
      action +
      " Medication</h2>\n        <p>" +
      GLOBAL_JCR.errorText +
      '</p>\n<div class="form-group">' +
      renderMedicationFormSectionList(props, mode) +
      '\n</div><div class="buttons-group">\n            ' +
      button +
      "\n            " +
      submitButtonsTpl(serverLoading) +
      "\n        </div>\n    </form>\n    "
    );
  };

  var submitButtonsTpl = function submitButtonsTpl(serverLoading) {
    if (serverLoading) {
      $(".ajax-loader--phs")
        .removeClass("hidden")
        .addClass("loader-active");
    }
    return '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row row-gutter-small-xs">\n              <div class="col-xs-6">\n                <input type="submit" class="btn btn--block btn--primary" value="Save">\n              </div>\n              <div class="col-xs-6">\n                <input type="reset" class="btn btn--block btn--secondary" value="Cancel">\n              </div>\n            </div>\n          </div>\n        </div>\n    ';
  };

  var renderAllergyFormSectionList = function renderAllergyFormSectionList(
    sections,
    mode
  ) {
    return sections.reduce(function(acc, cur, index, arr) {
      var allergyTitle =
        mode === "add"
          ? '\n            <button class="btn-link internal-link h5" data-action="remove-allergy" data-id="' +
            index +
            '">Remove allergy ' +
            (index + 1) +
            "</button>\n            "
          : "";

      return (
        "\n            " +
        acc +
        '\n            <section class="record" data-allergy-index="' +
        index +
        '" data-allergy-id="' +
        cur.id +
        '">\n                <h3 class="allergy-title" tabindex="-1">Allergy ' +
        (index + 1) +
        " " +
        allergyTitle +
        '</h3>\n                <div class="row">\n                    <div class="col-xs-12 col-md-6">\n                        <div class="form-group substance">\n                            <label for="substance' +
        index +
        '" class="btn--block">' +
        GLOBAL_JCR.substanceAgentText +
        '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="substance' +
        index +
        '" class="form-control" name="substances[]" value="' +
        cur.substance +
        '">\n                                </span>\n                            </label>\n                        </div>\n                        <fieldset>\n                            <legend>Adverse Reactions</legend>\n                            <ul class="reaction-list">\n                                ' +
        rederReactionsList("allergy" + index, cur.reaction) +
        '\n                            </ul>\n                            <button type="button" class="btn-link internal-link" data-action="add-reaction" data-allergy-index="' +
        index +
        '">Add another reaction</button>\n                        </fieldset>\n                    </div>\n                </div>\n            </section>\n        '
      );
    }, "");
  };

  var renderMedicationFormSectionList = function renderMedicationFormSectionList(
    sections,
    mode
  ) {
    var JCR =
      arguments.length > 2 && arguments[2] !== undefined
        ? arguments[2]
        : JSON.parse($("#medicationJRCData").val());

    return sections.reduce(function(acc, cur, index, arr) {
      var title =
        mode === "add"
          ? '\n            <button class="btn-link internal-link h5" data-action="remove-medication" data-id="' +
            index +
            '">Remove medication ' +
            (index + 1) +
            "</button>\n            "
          : "";

      return (
        "\n            " +
        acc +
        '\n            <section class="record" data-medication-index="' +
        index +
        '" data-medication-id="' +
        cur.id +
        '">\n                <h3 class="medication-title" tabindex="-1">Medication ' +
        (index + 1) +
        " " +
        title +
        '</h3>\n                <div class="row">\n                    <div class="col-xs-12 col-md-6">\n                        <div class="form-group medicine">\n                            <label for="medicine' +
        index +
        '" class="btn--block">' +
        GLOBAL_JCR.medicine +
        '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="medicine' +
        index +
        '" class="form-control" name="medicines[]" value="' +
        cur.medicineDescription +
        '">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group dose">\n                            <label for="dose' +
        index +
        '" class="btn--block">' +
        GLOBAL_JCR.dose +
        '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="dose' +
        index +
        '" class="form-control" name="doses[]" value="' +
        cur.medicationDose +
        '">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group reason">\n                            <label for="reason' +
        index +
        '" class="btn--block">' +
        GLOBAL_JCR.reason +
        ' (optional)\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="reason' +
        index +
        '" class="form-control" name="reasons[]" value="' +
        cur.medicineReason +
        '">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group comment">\n                            <label for="comment' +
        index +
        '" class="btn--block">' +
        GLOBAL_JCR.comments +
        ' (optional)\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="comment' +
        index +
        '" class="form-control" name="comments[]" value="' +
        cur.medicationComments +
        '">\n                                </span>\n                            </label>\n                        </div>\n                    </div>\n                </div>\n            </section>\n        '
      );
    }, "");
  };

  var renderAllergyRemoveList = function renderAllergyRemoveList(items) {
    return items.reduce(function(acc, cur, index, arr) {
      return (
        "\n            " +
        acc +
        '\n            <li data-index="' +
        cur.id +
        '">\n                ' +
        cur.substance +
        " " +
        (cur.reaction.length > 0 ? "- " + cur.reaction.join(",") : "") +
        "\n            </li>\n        "
      );
    }, "");
  };

  var renderMedicationRemoveList = function renderMedicationRemoveList(items) {
    return items.reduce(function(acc, cur, index, arr) {
      return (
        "\n            " +
        acc +
        '\n            <li data-index="' +
        cur.id +
        '">\n                ' +
        cur.medicineDescription +
        " - " +
        cur.medicationDose +
        "\n            </li>\n        "
      );
    }, "");
  };

  var rederReactionsList = function rederReactionsList(record, reaction) {
    return reaction.reduce(function(acc, cur, index, arr) {
      return (
        "\n            " +
        acc +
        '\n            <li>\n                <div class="form-group">\n                    <label for="' +
        record +
        "-reaction" +
        index +
        '">Reaction ' +
        (index + 1) +
        ' (optional)\n                        <span class="validation-wrapper validation-wrapper--input">\n                            <input id="' +
        record +
        "-reaction" +
        index +
        '" class="form-control" name="reactions[]" value="' +
        cur +
        '">\n                        </span>\n                    </label>\n                      <button type="button" class="btn-link internal-link" data-action="remove-reaction" data-allergy-index="' +
        record.replace("allergy", "") +
        '" data-reaction-index="' +
        index +
        '">Remove reaction ' +
        (index + 1) +
        "</button>\n                </div>\n            </li>\n        "
      );
    }, "");
  };
  var noDataTpl = function noDataTpl() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "No consumer entered allergies or adverse reactions recorded.";
    var id =
      arguments.length > 1 && arguments[1] !== undefined
        ? arguments[1]
        : "adverse-reaction-no-data";

    return (
      '\n        <div id="' +
      id +
      '">\n          <div class="alert alert--notification alert--white alert--border--sky-blue " role="alert" aria-describedby="alert-description-'+id+'">\n              <div class="alert__icon">\n                <span class="icon icon--sm icon--info-circle">\n                  <span class="sr-only">Alert Information</span>\n                  <span class="print__icon">\n                      <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                  </span>\n                </span>\n              </div>\n              <div class="alert__message ">\n                <div class="alert__message__content" id="alert-description-'+id+'">' +
      text +
      "</div>\n              </div>\n\n          </div>\n      </div>\n    "
    );
  };

  var error = function error() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "" + GLOBAL_JCR.alertContent;

    return (
      '\n        <div class="container">\n            <div class="alert alert--white  alert--border--red alert--notification">\n                <div class="alert__icon">\n                    <span class="icon icon--sm icon--error">\n                    <span class="sr-only">Alert Error</span>\n                          <span class="print__icon">\n                              <svg width="27" height="23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Error</title><defs><path d="M11.5 0L-2.3 23h27.6z"/></defs><g fill="none" fill-rule="evenodd"><g transform="translate(2)"><use fill="#1F6DB1" xlink:href="#a"/><use fill="#D0021B" xlink:href="#a"/></g><path d="M12.35 10.35h2.3v-2.3h-2.3v2.3zm0 9.2h2.3v-6.9h-2.3v6.9z" fill="#FFF"/></g></svg>\n                          </span>\n                    </span>\n                </div>\n                <div class="alert__message h5">\n                  <div class="alert__message__content"><p>' +
      text +
      "</p></div>\n\n                </div>\n            </div>\n        </div>\n    "
    );
  };

  var allergyModalContent = function allergyModalContent(mode, action) {
    var multiAdd =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

    if (mode === "add") {
      return action === "cancel"
        ? '<div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the information entered</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal"> ' +
            (multiAdd == true
              ? "You've added your allergies and adverse reactions"
              : "You've added an allergy and adverse reaction") +
            '</h2>\n </div>\n <div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n            ';
    }

    if (mode === "edit") {
      return action === "cancel"
        ? '\n             <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the edits you made in allergy and adverse reaction</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : ' \n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            (multiAdd == true
              ? "You've updated your allergies and adverse reactions"
              : "You've updated an allergy and adverse reaction") +
            '</h2>\n </div>\n  <div class="modal-body"><p>Please select Ok to continue.</p></div>\n          <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>';
    }

	  if (mode.indexOf("remove") !==-1) {
	  return action==="cancel"
	  ?'\n <div class="modal-header">\n <h2 class="modal-title h4" id="form-submit-modal">'+
	  GLOBAL_JCR.infoTextCancel+
	  '</h2>\n </div>\n <div class="modal-body"><p>Are you sure you want to cancel the changes?</p></div>\n <div class="modal-footer">\n <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n </div>\n '
	  :'\n <div class="modal-header">\n <h2 class="modal-title h4" id="form-submit-modal">'+
	  GLOBAL_JCR.infoTextSave+
	  '</h2>\n </div>\n <div class="modal-body"><p>Are you sure you want to remove this information?</p></div>\n <div class="modal-footer">\n <button type="submit" class="btn btn--primary">Yes</button>\n <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n </div>\n\n ';
	  }
	   
	  return"\n\n ";
  };

  var medicationModalContent = function medicationModalContent(mode, action) {
    var multiAdd =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

    if (mode === "add") {
      return action === "cancel"
        ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            GLOBAL_JCR.medicationCancelText +
            '</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            (multiAdd == true
              ? GLOBAL_JCR.mediactionNewSavesText
              : GLOBAL_JCR.mediactionNewSaveText) +
            '</h2>\n </div>\n <div class="modal-body"><p>Please select Ok to continue.</p></div>\n <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
    }

    if (mode === "edit") {
      return action === "cancel"
        ? '\n             <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            GLOBAL_JCR.medicationCancelText +
            '</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            GLOBAL_JCR.medicationEditSaveText +
            '</h2>\n </div>\n  <div class="modal-body"><p>Please select Ok to continue.</p></div>\n          <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
    }

    if (mode.indexOf("remove") !== -1) {
      return action === "cancel"
        ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            GLOBAL_JCR.medsCancelAlert +
            '</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure want to cancel the changes?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary btn--cancel-yes">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">' +
            GLOBAL_JCR.medsRemoveAlert +
            '</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to remove this information?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n\n        ';
    }

    return "\n\n    ";
  };

  // helpers

  var getAllergyHintText = function getAllergyHintText(mode) {
    if (mode === "add") return "<p>" + GLOBAL_JCR.aarNote2 + "</p>";

    if (mode === "edit") return "<p>" + GLOBAL_JCR.aarNote3 + "</p>";

    if (mode === "remove") return "<p>" + GLOBAL_JCR.aarNote4 + "</p>";

    return "";
  };
  var getMedicineHintText = function getMedicineHintText(mode) {
    if (mode === "add") return "<p>" + GLOBAL_JCR.medsNote1 + "</p>";

    if (mode === "edit") return "<p>" + GLOBAL_JCR.medsNote2 + "</p>";

    if (mode === "remove") return "<p>" + GLOBAL_JCR.medsNote3 + "</p>";

    return "";
  };
  var getActionText = function getActionText(mode) {
    if (mode === "add") return "Add";
    if (mode === "edit") return "Edit";
    if (mode.indexOf("remove") !== -1) return "Remove";
    return "";
  };

  var allergyTableDoAction = function allergyTableDoAction(e, status) {
    status === "editing" && store.dispatch({ type: "ALLERGY_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "ALLERGY_ENTER_REMOVE_MODE" });

    var $action = $(e.target);
    var id = $action.data("id");

    var tableData = store.getState().allergyTable;
    var formData = store.getState().allergyForm;

    var index = tableData.map(function(item) {
      return item.id;
    }).indexOf(id);;
    var item = tableData[index];

    store.dispatch({ type: "ALLERGY_FORM_INSERT_SECTION", item: item });
    store.dispatch({
      type: "ALLERGY_TABLE_UPDATE",
      item: _extends({}, item, { status: status }),
      index: index
    });

    $("#allergy-focus-content").focus();
  };

  var medicationTableDoAction = function medicationTableDoAction(e, status) {
    status === "editing" &&
      store.dispatch({ type: "MEDICATION_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "MEDICATION_ENTER_REMOVE_MODE" });

    var $action = $(e.target);
    var id = $action.data("id");

    var tableData = store.getState().medicationTable;
    var formData = store.getState().medicationForm;

    var index = tableData.map(function(item) {
      return item.id;
    }).indexOf(id);
    var item = tableData[index];

    store.dispatch({ type: "MEDICATION_FORM_INSERT_SECTION", item: item });
    store.dispatch({
      type: "MEDICATION_TABLE_UPDATE",
      item: _extends({}, item, { status: status }),
      index: index
    });

    $("#medication-focus-content").focus();
  };

  var allergyTableUndoAction = function allergyTableUndoAction(e, status) {
    status === "editing" && store.dispatch({ type: "ALLERGY_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "ALLERGY_ENTER_REMOVING_MODE" });

    var $action = $(e.target);
    var $actioningRows = $("#adverse-reaction-table table tr." + status);

    if ($actioningRows.length === 1) {
      store.dispatch({ type: "ALLERGY_ENTER_INIT_MODE" });
    }

    var id = $action.data("id");

    var tableData = store.getState().allergyTable;
    var formData = store.getState().allergyForm;

    var indexInTable = tableData.map(function(item) {
      return item.id;
    }).indexOf(id);;
    var indexInForm = formData.map(function(item) {
      return item.id;
    }).indexOf(id);;
    var tableItem = tableData[indexInTable];

    store.dispatch({ type: "ALLERGY_FORM_REMOVE_SECTION", index: indexInForm });
    store.dispatch({
      type: "ALLERGY_TABLE_UPDATE",
      item: _extends({}, tableItem, { status: "saved" }),
      index: indexInTable
    });
  };

  var medicationTableUndoAction = function medicationTableUndoAction(
    e,
    status
  ) {
    status === "editing" &&
      store.dispatch({ type: "MEDICATION_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "MEDICATION_ENTER_REMOVING_MODE" });

    var $action = $(e.target);
    var $actioningRows = $("#medication-table table tr." + status);

    if ($actioningRows.length === 1) {
      store.dispatch({ type: "MEDICATION_ENTER_INIT_MODE" });
    }

    var id = $action.data("id");

    var tableData = store.getState().medicationTable;
    var formData = store.getState().medicationForm;

    var indexInTable = tableData.map(function(item) {
      return item.id;
    }).indexOf(id);;
    var indexInForm = formData.map(function(item) {
      return item.id;
    }).indexOf(id);;
    var tableItem = tableData[indexInTable];

    store.dispatch({
      type: "MEDICATION_FORM_REMOVE_SECTION",
      index: indexInForm
    });
    store.dispatch({
      type: "MEDICATION_TABLE_UPDATE",
      item: _extends({}, tableItem, { status: "saved" }),
      index: indexInTable
    });
  };

  var getDocListData = function getDocListData(_ref) {
    var url = _ref.url,
      _ref$type = _ref.type,
      type = _ref$type === undefined ? "get" : _ref$type,
      data = _ref.data;

    var defer = $.Deferred();
    var ajaxConfig = {
      url: url,
      type: type,
      data: {
        jsonObj: JSON.stringify({ docListValue: $("#rimDescription").val() })
      },
      success: function success(response) {
        if (response == null) {
          return defer.reject("DOCLIST_NULL");
        }
        var responseempty = response[0][0];
        var usertype = response[0][1];
        if (responseempty === true) {
          if (usertype === "NR") {
            return defer.reject("DOCLIST_EMPTY_WITH_NR");
          }
          return defer.reject("DOCLIST_EMPTY");
        }
        return defer.resolve(response);
      },
      error: defer.reject
    };
    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var getPHSData = function getPHSData(_ref2) {
    var url = _ref2.url,
      _ref2$type = _ref2.type,
      type = _ref2$type === undefined ? "get" : _ref2$type;

    var defer = $.Deferred();

    var ajaxConfig = {
      url: url,
      type: type,
      success: function success(response) {
        if (typeof response === "string") {
          if (
            response == null ||
            response == "PCEHR_ERROR_0005" ||
            response == "PCEHR_ERROR_DEFAULT" ||
            response == ""
          ) {
            return defer.reject("PHS_SERVER_ERROR");
          }

          return defer.resolve(JSON.parse(response));
        }

        return defer.resolve(response);
      },
      error: defer.reject
    };

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var getJCR = function getJCR(_ref3) {
    var url = _ref3.url,
      _ref3$type = _ref3.type,
      type = _ref3$type === undefined ? "get" : _ref3$type;

    var defer = $.Deferred();

    var ajaxConfig = {
      url: url,
      type: type,
      success: function success(response) {
        if (typeof response === "string") {
          if (
            response == null ||
            response == "PCEHR_ERROR_0005" ||
            response == "PCEHR_ERROR_DEFAULT" ||
            response == ""
          ) {
            return defer.reject("PHS_SERVER_ERROR");
          }

          return defer.resolve(JSON.parse(response).responseJson);
        }

        return defer.resolve(response.responseJson);
      },
      error: defer.reject
    };

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var fetchAllData = function fetchAllData(docListAjaxConfig, PHSAjaxConfig) {
    var defer = $.Deferred();
    getDocListData(docListAjaxConfig)
      .done(function(response) {
        getPHSData(PHSAjaxConfig)
          .done(defer.resolve)
          .fail(defer.reject);
      })
      .fail(function(error) {
        if ("DOCLIST_EMPTY" === error) {
          $(".toolbar-nav").addClass("hidden");

          return defer.resolve({
            allergiesItems: [],
            medicineItems: []
          });
        }

        if ("DOCLIST_EMPTY_WITH_NR" === error) {
          $(".toolbar-nav").addClass("hidden");

          return defer.resolve({
            NRstatus: "NR",
            allergiesItems: [],
            medicineItems: []
          });
        }

        $(".toolbar-nav").removeClass("hidden");

        return defer.reject(error);
      });

    return defer.promise();
  };

  var postToCDA = function postToCDA(_ref4) {
    var url = _ref4.url,
      data = _ref4.data,
      _ref4$type = _ref4.type,
      type = _ref4$type === undefined ? "post" : _ref4$type,
      _ref4$dataType = _ref4.dataType,
      dataType = _ref4$dataType === undefined ? "html" : _ref4$dataType;

    var defer = $.Deferred();
	$(".ajax-loader--phs").removeClass("hidden").addClass("loader-active");

    var ajaxConfig = {
      url: url,
      type: type,
      data: data,
      dataType: dataType,
      success: function success(response) {
        if ("success" === $.trim(response)) {
          return defer.resolve("CDA_SUCCESS");
        }
        return defer.reject("CDA_SERVER_ERROR");
      },
      error: defer.reject
    };

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var submitDataToCDA = function submitDataToCDA() {
    var submitFromSection =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "allergy";

    var state = store.getState();

    var data = createPostDataToCDA(state, submitFromSection);

    store.dispatch({ type: "SUBMIT_DATA_TO_REMOTE", payload: data });

    var preparePostCDA = void 0;

    if (window.location.host.indexOf("localhost:3000") !== -1) {
      preparePostCDA = postToCDA({
        url: "/js/data/cdaUpload.json",
        type: "get"
      });
    } else {
      preparePostCDA = postToCDA({ url: "/ncp/cdaUpload", data: data });
    }

    return preparePostCDA
      .done(function(message) {
        store.dispatch({
          type: "SUBMIT_DATA_TO_REMOTE_SUCCESS",
          successResponse: message
        });
        return message;
      })
      .fail(function(error) {
        store.dispatch({ type: "SUBMIT_DATA_TO_REMOTE_FAIL", error: error });
        return error;
      });
  };

  var createPostDataToCDA = function createPostDataToCDA(storeState) {
    var select =
      arguments.length > 1 && arguments[1] !== undefined
        ? arguments[1]
        : "allergy";
    var allergyForm = storeState.allergyForm,
      medicationForm = storeState.medicationForm,
      allergyTable = storeState.allergyTable,
      medicationTable = storeState.medicationTable,
      allergyMode = storeState.allergyMode,
      medicationMode = storeState.medicationMode,
      server = storeState.server;

    var docDetails = {
      docType: "CEHS",
      docId: server.payload.documentId || "",
      repoId: server.payload.repositoryId || "",
      action: "edit"
    };

    if (select === "allergy") {
      docDetails.MedicationList = prepareCDADataList(medicationTable, "none");

      docDetails.AARList = getDataList(
        reFormatAllergyTable(allergyForm),
        reFormatAllergyTable(allergyTable),
        allergyMode.mode
      );
    } else {
      docDetails.AARList = prepareCDADataList(
        reFormatAllergyTable(allergyTable),
        "none"
      );

      docDetails.MedicationList = getDataList(
        medicationForm,
        medicationTable,
        medicationMode.mode
      );
    }

    var documentJson = encodeURIComponent(JSON.stringify(docDetails));

    return (
      "documentJson=" +
      documentJson +
      "&documentId=" +
      docDetails.docId +
      "&repositoryId=" +
      docDetails.repoId
    );
  };

  var reFormatAllergyTable = function reFormatAllergyTable(allergyTable) {
    return JSON.parse(JSON.stringify(allergyTable)).map(function(item) {
      item.reactions = item.reaction.join("~`~");
      delete item.reaction;
      return item;
    });
  };

  var prepareCDADataList = function prepareCDADataList(list) {
    var action =
      arguments.length > 1 && arguments[1] !== undefined
        ? arguments[1]
        : "none";

    return list.map(function(item) {
      var itemClone = JSON.parse(JSON.stringify(item));
      itemClone.action = action;

      itemClone.status && delete itemClone.status;

      return itemClone;
    });
  };

  var getDataList = function getDataList(formData, tableData, mode) {
    if (mode === "add") {
      return [].concat(
        _toConsumableArray(prepareCDADataList(tableData, "none")),
        _toConsumableArray(prepareCDADataList(formData, "new"))
      );
    }

    if (mode === "edit") {
      return [].concat(
        _toConsumableArray(
          tableData.map(function(item) {
            var tableItem = JSON.parse(JSON.stringify(item));

            if ("editing" === tableItem.status) {
              tableItem.action = "delete";
            } else {
              tableItem.action = "none";
            }

            tableItem.status && delete tableItem.status;

            return tableItem;
          })
        ),
        _toConsumableArray(
          formData.map(function(item) {
            var formItem = JSON.parse(JSON.stringify(item));
            formItem.action = "new";
            formItem.id = "";

            formItem.status && delete formItem.status;

            return formItem;
          })
        )
      );
    }

    if (mode.indexOf("remove") !== -1) {
      return tableData.map(function(item) {
        var tableItem = JSON.parse(JSON.stringify(item));

        if ("removing" === tableItem.status) {
          tableItem.action = "delete";
        } else {
          tableItem.action = "none";
        }

        tableItem.status && delete tableItem.status;

        return tableItem;
      });
    }
  };

  // App

  $(function() {
    store.dispatch({ type: "FETCH_REMOTE_DATA" });
    store.dispatch({ type: "FETCH_REMOTE_JCR" });

    var host = window.location.host;

    var fetchDataPromise = void 0;
    var lastUpdateInfo = void 0;
    var fetchJCR = void 0;

    if (host.indexOf("localhost:3000") !== -1) {
      fetchDataPromise = fetchAllData(
        { url: "/js/data/getDocListData.json" },
        { url: "/js/data/getPersonalHealthSummary.json" }
      );
      fetchJCR = getJCR({ url: "/js/data/getPHSJCR.json" });
    } else {
      fetchDataPromise = fetchAllData(
        { url: "/ncp/getDocListData", type: "post" },
        { url: "/ncp/getPersonalHealthSummary", type: "post" }
      );
      var url = "/" + $("#jcr").val();
      fetchJCR = getJCR({ url: url });
    }

    fetchJCR
      .done(function(data) {
        if (typeof data === "string") {
          return store.dispatch({
            type: "FETCH_REMOTE_JCR_SUCCESS",
            payload: JSON.parse(data)
          });
        }
        return store.dispatch({
          type: "FETCH_REMOTE_JCR_SUCCESS",
          payload: data
        });
      })
      .fail(function(error) {
        return store.dispatch({ type: "FETCH_REMOTE_JCR_FAIL", error: error });
      });

    fetchDataPromise
      .done(function(data) {
        rm.sessionStorage.removeSession("statusMode");
        if ("NR" === data.NRstatus) {
          store.dispatch({ type: "ALLERGY_RESTRICT_MODE" });
          store.dispatch({ type: "MEDICATION_RESTRICT_MODE" });
          $(".toolbar-nav .btn__remove-phs")
            .parent()
            .addClass("hidden");
          rm.sessionStorage.setSession("statusMode", "restricted");
        }

        store.dispatch({
          type: "ALLERGY_TABLE_INIT",
          items: data.allergiesItems.map(function(item) {
            item.status = "saved";
            return item;
          })
        });

        store.dispatch({
          type: "MEDICATION_TABLE_INIT",
          items: data.medicineItems.map(function(item) {
            item.status = "saved";
            return item;
          })
        });
        store.dispatch({ type: "FETCH_REMOTE_DATA_SUCCESS", payload: data });

        if (rm) rm.sessionScroll.readjustView();
      })
      .fail(function(error) {
        store.dispatch({ type: "FETCH_REMOTE_DATA_FAIL", error: error });
      });
  });

  var elemSelector = {
    rmvBtnToolbar: ".toolbar-nav .btn__remove-phs"
  };
  
  var yesBtn = false;
  
  //manage returning focus
  $(document).on('click', '[data-action]', function() {

    var mode = $(this).attr('data-action');
    
    if(mode === 'undo-remove' || mode === 'undo-edit') {
      var dataId = $(this).attr('data-id');
      var target = $('[data-id="' + dataId + '"][data-action="' + mode.replace('undo-', '') + '"]').get(0);

      target.focus();
    }
    
    if(mode === 'edit' || mode === 'remove') {
      var dataId = $(this).attr('data-id');
      var table = $(this).parents('table').first();
    }
    
    var cancelReturn = false;
    
    $('#allergy-form-submit-modal, #medication-form-submit-modal').on('shown.bs.modal', function() {
      $(this).attr('disable-return-focus', true);
      cancelReturn = false;
      $(this).find('.btn--primary').on('click', function() {
        cancelReturn = true;
      });
    }).on('hidden.bs.modal', function(e) {
      e.preventDefault();
      
      if(cancelReturn) {
        cancelReturn = false;
        
        switch(mode) {
          case 'edit' :
            var target = $('[data-id="' + dataId + '"]').not('*[data-action="remove"]').get(0);
            break;
            
          case 'remove':
            var target = $('[data-id="' + dataId + '"]').not('*[data-action="edit"]').get(0);
            break;
            
          case 'add-allergy':
            var target = $('*[data-action="add-allergy"]').get(0);
            break;
            
          case 'add-medication':
            var target = $('*[data-action="add-medication"]').get(0);
            break;
            
        }

      } else {
        var btnOrigin = (yesBtn) ?  '.btn--primary' : '.btn--secondary';
        
        if($(this).is($('#allergy-form-submit-modal'))) {
          target = $('#adverse-reaction-form').find(btnOrigin).get(0);
        }
        
        if($(this).is($('#medication-form-submit-modal'))) {
          target = $('#medication-form').find(btnOrigin).get(0);
        }
      }
      
      if(target) focusEl(target);
        
    });
    
    function focusEl(el) {
      window.setTimeout(function() { //necessary if button is recreated or disabled
        $(el).focus();
      }, 0);
    }
      
  });
  
  $('#medication-form, #adverse-reaction-form').on('click', '.btn--primary', function() {
    yesBtn = true;
  });
  
  $('#medication-form, #adverse-reaction-form').on('click', '.btn--secondary', function() {
    yesBtn = false;
  });
  
  
  var isFrstTr = false;

  $("#adverse-reactions")
    .on("click", '[data-action="add-allergy"]', function(e) {
      e.preventDefault();
      store.dispatch({ type: "ALLERGY_ENTER_ADD_MODE" });
      store.dispatch({ type: "ALLERGY_FORM_ADD_SECTION" });
      var $sections = $("section[data-allergy-index]");

      if ($sections.length > 1) {
        $sections
          .last()
          .find(".allergy-title")
          .focus();
      } else {
        $("#allergy-focus-content").focus();
      }
    })
    .on("click", '[data-action="remove-allergy"]', function(e) {
      e.preventDefault();
      var $remove = $(e.target);
      store.dispatch({
        type: "ALLERGY_FORM_REMOVE_SECTION",
        index: $remove.data("id")
      });
      var $last = $("section[data-allergy-index]").last();
      if ($last.length > 0) {
        $last.find(".allergy-title").focus();
      } else {
        store.dispatch({ type: "ALLERGY_ENTER_INIT_MODE" });
      }
    })
    .on("click", '[data-action="add-reaction"]', function(e) {
      e.preventDefault();
      var $add = $(e.target);
      var index = $add.data("allergy-index");
      store.dispatch({ type: "ALLERGY_FORM_ADD_REACTION", index: index });
      $('section[data-allergy-index="' + index + '"]')
        .find("input")
        .last()
        .focus();
    })
    .on("click", '[data-action="remove-reaction"]', function(e) {
      e.preventDefault();
      var $remove = $(e.target);
      store.dispatch({
        type: "ALLERGY_FORM_REMOVE_REACTION",
        allergyIndex: $remove.data("allergy-index"),
        reactionIndex: $remove.data("reaction-index")
      });
      $('[data-action="add-reaction"]').focus();
    })
    .on("input", function(e) {
      var $input = $(e.target);
      var $section = $input.closest(".record");
      var index = $section.data("allergy-index");
      var id = $section.data("allergy-id");
      var substance = $section.find(".substance input").val();
      var reaction = Array.prototype.map.call(
        $section.find(".reaction-list input"),
        function(item) {
          return $(item).val();
        }
      );

      unsubscribe();
      store.dispatch({
        type: "ALLERGY_FORM_UPDATE_SECTION",
        item: { id: id, substance: substance, reaction: reaction },
        index: index
      });
      unsubscribe = store.subscribe(handleChange);
    })
    .on("click", 'input[type="reset"]', function(e) {
      e.preventDefault();

      var mode = store.getState().allergyMode.mode;

      $("#allergy-form-submit-modal .modal-content").html(
        allergyModalContent(mode, "cancel")
      );
      $("#allergy-form-submit-modal").modal("show");

      if (-1 !== mode.indexOf("remove")) {
        store.dispatch({ type: "ALLERGY_ENTER_CANCEL_REMOVE_MODE" });
      }
    })
    .on("click", 'input[type="submit"]', function(e) {
      e.preventDefault();
      var $submit = $(e.target);
      var $form = $submit.closest("form");
      var validators = rm.validation.getValidators();
      var argArray = [
        ["addField", "substances[]", validators.substance],
        ["addField", "substances[]", validators.no_blacklistCharacters],
        ["addField", "reactions[]", validators.no_blacklistCharacters],
        ["addField", "reactions[]", validators.max300char],
        [
          "updateMessage",
          "substances[]",
          "notEmpty",
          "Please enter the substance or agent using letters and numbers only."
        ],
        [
          "updateMessage",
          "substances[]",
          "regexp",
          "Please enter the substance or agent using letters and numbers only."
        ],
        [
          "updateMessage",
          "reactions[]",
          "regexp",
          "Please enter the reaction using letters and numbers only."
        ]
      ];

      $form.on('submit', function(e) {
        e.preventDefault();
      });

      rm.validation.customInit($form, argArray);
      if (rm.validation.isFormValid($form)) {
        var state = store.getState();

        var mode = state.allergyMode.mode;
        var multiAdd = state.allergyForm.length > 1 ? true:false;

        if (-1 !== mode.indexOf("remove")) {
          $("#allergy-form-submit-modal .modal-content").html(
            allergyModalContent(mode, "submit")
          );
          $("#allergy-form-submit-modal").modal("show");
          store.dispatch({ type: "ALLERGY_ENTER_SAVE_REMOVE_MODE" });
          return;
        }

        submitDataToCDA("allergy")
          .done(function(response) {
            store.dispatch({ type: "ALLERGY_ENTER_SAVE_MODE" });
            $("#allergy-form-submit-modal .modal-content").html(
              allergyModalContent(mode, "submit",multiAdd)
            );
            $("#allergy-form-submit-modal").modal("show");
          })
          .fail(function(error) {
            return console.log(error);
          });
      }
    });

  $("#current-medications-section")
    .on("click", '[data-action="add-medication"]', function(e) {
      e.preventDefault();
      store.dispatch({ type: "MEDICATION_ENTER_ADD_MODE" });
      store.dispatch({ type: "MEDICATION_FORM_ADD_SECTION" });
      var $sections = $("section[data-medication-index]");

      if ($sections.length > 1) {
        $sections
          .last()
          .find(".medication-title")
          .focus();
      } else {
        $("#medication-focus-content").focus();
      }
    })
    .on("click", '[data-action="remove-medication"]', function(e) {
      e.preventDefault();
      var $remove = $(e.target);
      store.dispatch({
        type: "MEDICATION_FORM_REMOVE_SECTION",
        index: $remove.data("id")
      });
      var $last = $("section[data-medication-index]").last();

      if ($last.length > 0) {
        $last.find(".medication-title").focus();
      } else {
        store.dispatch({ type: "MEDICATION_ENTER_INIT_MODE" });
      }
    })
    .on("input", function(e) {
      var $input = $(e.target);
      var $section = $input.closest(".record");
      var index = $section.data("medication-index");
      var id = $section.data("medication-id");
      var medicineDescription = $section.find(".medicine input").val();
      var medicationDose = $section.find(".dose input").val();
      var medicineReason = $section.find(".reason input").val();
      var medicationComments = $section.find(".comment input").val();

      unsubscribe();
      store.dispatch({
        type: "MEDICATION_FORM_UPDATE_SECTION",
        item: {
          id: id,
          medicineDescription: medicineDescription,
          medicationDose: medicationDose,
          medicineReason: medicineReason,
          medicationComments: medicationComments
        },
        index: index
      });
      unsubscribe = store.subscribe(handleChange);
    })
    .on("click", 'input[type="reset"]', function(e) {
      e.preventDefault();

      var mode = store.getState().medicationMode.mode;

      $("#medication-form-submit-modal .modal-content").html(
        medicationModalContent(mode, "cancel")
      );
      $("#medication-form-submit-modal").modal("show");

      if (-1 !== mode.indexOf("remove")) {
        store.dispatch({ type: "MEDICATION_ENTER_CANCEL_REMOVE_MODE" });
      }
    })
    .on("click", 'input[type="submit"]', function(e) {
      e.preventDefault();
      var $submit = $(e.target);
      var $form = $submit.closest("form");
      var validators = rm.validation.getValidators();
      var argArray = [
        ["addField", "medicines[]", validators.substance],
        ["addField", "medicines[]", validators.no_blacklistCharacters],
        ["addField", "doses[]", validators.substance],
        ["addField", "doses[]", validators.no_blacklistCharacters],
        ["addField", "reasons[]", validators.no_blacklistCharacters],
        ["addField", "comments[]", validators.no_blacklistCharacters],
        ["addField", "reasons[]", validators.max300char],
        ["addField", "comments[]", validators.max300char],
        [
          "updateMessage",
          "medicines[]",
          "notEmpty",
          "Please enter the medicine using letters or number only."
        ],
        [
          "updateMessage",
          "doses[]",
          "notEmpty",
          "Please enter the dose information using letters or number only."
        ],
        [
          "updateMessage",
          "medicines[]",
          "regexp",
          "Please enter the medicine using letters or number only."
        ],
        [
          "updateMessage",
          "doses[]",
          "regexp",
          "Please enter the dose information using letters or number only."
        ],
        [
          "updateMessage",
          "reasons[]",
          "regexp",
          "Please enter the reason for taking medication using letters or numbers only."
        ],
        [
          "updateMessage",
          "comments[]",
          "regexp",
          "Please enter the additional comments using letters or numbers only."
        ]
      ];

      $form.on('submit', function(e) {
        e.preventDefault();
      });

      rm.validation.customInit($form, argArray);
      if (rm.validation.isFormValid($form)) {
        var state = store.getState();
        var mode = state.medicationMode.mode;
        var multiAdd = state.medicationForm.length > 1 ? true : false;
        var data = createPostDataToCDA(state, "medication");

        if (-1 !== mode.indexOf("remove")) {
          $("#medication-form-submit-modal .modal-content").html(
            medicationModalContent(mode, "submit")
          );
          $("#medication-form-submit-modal").modal("show");
          store.dispatch({ type: "MEDICATION_ENTER_SAVE_REMOVE_MODE" });

          return;
        }

        submitDataToCDA("medication")
          .done(function(response) {
            store.dispatch({ type: "MEDICATION_ENTER_SAVE_MODE" });
            $("#medication-form-submit-modal .modal-content").html(
              medicationModalContent(mode, "submit", multiAdd)
            );
            $("#medication-form-submit-modal").modal("show");
          })
          .fail(function(error) {
            return console.log(error);
          });
      }
    });

  $("#adverse-reaction-table")
    .on("click", '[data-action="edit"]', function(e) {
      e.preventDefault();
      allergyTableDoAction(e, "editing");
      $('.toolbar-nav').addClass('hidden');
    })
    .on("click", '[data-action="undo-edit"]', function(e) {
      e.preventDefault();
      allergyTableUndoAction(e, "editing");
    })
    .on("click", '[data-action="remove"]', function(e) {
      e.preventDefault();
      allergyTableDoAction(e, "removing");
      $('.toolbar-nav').addClass('hidden');
    })
    .on("click", '[data-action="undo-remove"]', function(e) {
      e.preventDefault();
      allergyTableUndoAction(e, "removing");
    });

  $("#medication-table")
    .on("click", '[data-action="edit"]', function(e) {
      e.preventDefault();
      medicationTableDoAction(e, "editing");
    })
    .on("click", '[data-action="undo-edit"]', function(e) {
      e.preventDefault();
      medicationTableUndoAction(e, "editing");
    })
    .on("click", '[data-action="remove"]', function(e) {
      e.preventDefault();
      medicationTableDoAction(e, "removing");
    })
    .on("click", '[data-action="undo-remove"]', function(e) {
      e.preventDefault();
      medicationTableUndoAction(e, "removing");
    });

  $("#allergy-form-submit-modal")
    .on("click", '[type="submit"]', function(e) {
      e.preventDefault();

      var state = store.getState();
      $("#allergy-form-submit-modal").modal("hide");
      redirectFlagAllergy("true");
      if (rm.sessionStorage.getSession("isMedInfoRedirect") === "false") {
        rm.sessionRedirect.clear();
      }
      if ($(this).hasClass('btn--cancel-yes')) {
        redirectFlagAllergy("false");
      }

      if (state.allergyMode.mode === "save") {
          store.dispatch({ type: "FETCH_REMOTE_DATA" });
          window.location.href = window.location.pathname;
          return;
        }

      if (state.allergyMode.mode === "save_remove") {
          submitDataToCDA("allergy").done(function(response) {
            store.dispatch({ type: "FETCH_REMOTE_DATA" });
            window.location.href = window.location.pathname;
            return;
          });
        }

      store.dispatch({ type: "ALLERGY_FORM_INIT" });
      store.dispatch({ type: "ALLERGY_ENTER_INIT_MODE" });
      store.dispatch({
        type: "ALLERGY_TABLE_INIT",
        items: state.server.payload.allergiesItems
      });
    })
    .on("click", '[type="reset"]', function(e) {
      e.preventDefault();
      var state = store.getState();
      var mode = state.allergyMode.mode;

      $("#allergy-form-submit-modal").modal("hide");

      if(mode === 'cancel_remove' || mode === 'add' || mode === 'edit') {
        $('#adverse-reaction-form input[type="reset"]').focus();
      } else if(mode === 'save_remove') {
        $('#adverse-reaction-form input[type="submit"]').focus();
      }
    });

  $("#medication-form-submit-modal")
    .on("click", '[type="submit"]', function(e) {
      e.preventDefault();

      var state = store.getState();

      $("#medication-form-submit-modal").modal("hide");
      redirectFlagMeds("true");
      if (rm.sessionStorage.getSession("isMedInfoRedirect") === "false") {
        rm.sessionRedirect.clear();
      }
      if ($(this).hasClass('btn--cancel-yes')) {
        redirectFlagMeds("false");
      }

      if (state.medicationMode.mode === "save") {
        window.location.href = window.location.pathname;
        store.dispatch({ type: "FETCH_REMOTE_DATA" });
        return;
      }

      if (state.medicationMode.mode === "save_remove") {
        submitDataToCDA("medication").done(function(response) {
          window.location.href = window.location.pathname;
          store.dispatch({ type: "FETCH_REMOTE_DATA" });
          return;
        });
      }

      store.dispatch({ type: "MEDICATION_FORM_INIT" });
      store.dispatch({ type: "MEDICATION_ENTER_INIT_MODE" });
      store.dispatch({
        type: "MEDICATION_TABLE_INIT",
        items: store.getState().server.payload.medicineItems
      });
    })
    .on("click", '[type="reset"]', function(e) {
      e.preventDefault();
      var state = store.getState();
      var mode = state.medicationMode.mode;

      $("#medication-form-submit-modal").modal("hide");

      if(mode === 'cancel_remove' || mode === 'add' || mode === 'edit') {
        $('#medication-form input[type="reset"]').focus();
      } else if(mode === 'save_remove') {
        $('#medication-form input[type="submit"]').focus();
      }
    });

  $(".btn__history").on("click", function(e) {
    var docid = "";
    var repoid = "";

    var firstTrChecked = $(
      '.toolbar-history table tbody > tr:first-child input[type="radio"]'
    );
    var historyCount = $(".toolbar-history table tbody > tr").length;

    $(".personal-health-summary .ajax-loader").removeClass("hidden");

    if (
      $(".btn__history").attr("data-mode") !== "show" ||
      typeof $(".btn__history").attr("data-mode") === "undefined"
    ) {
      showHideRmveBtn("hide");
    } else {
      if (firstTrChecked.is(":checked") === true || historyCount === 1) {
        if($('.action .btn-group').length !== 0) $('.action .btn-group').removeClass('hidden');
        if($('.ShowHidePHSElem').length !== 0) $('.ShowHidePHSElem').removeClass('hidden');
      }
    }
  });

  $(".toolbar-history table tbody").on("click", "tr", function(e) {
    e.preventDefault();

    var $this = $(this);
    var docid = $.trim($this.attr("data-docid"));
    var repoid = $.trim($this.attr("data-repoid"));

    getHistoryData({
      url: "/ncp/getPersonalHealthSummary",
      type: "post",
      docid: docid,
      repoid: repoid,
      mode: "history"
    })

      .done(function(data) {
        updateTableData(data);
        checkHistIfLatest($this);
      })
      .fail(function(error) {
        store.dispatch({ type: "FETCH_REMOTE_DATA_FAIL", error: error });
        console.log(error);
      });
  });

  var redirectFlagAllergy = function redirectFlagAllergy(flag) {
    rm.sessionStorage.setSession(
      "isMedInfoRedirect",
      rm.sessionStorage.getSession("SessionRedirectSource") === "allergy-link" &&
      flag === "true"
        ? "true"
        : "false"
    );
  };

  var redirectFlagMeds = function redirectFlagMeds(flag) {
    rm.sessionStorage.setSession(
      "isMedInfoRedirect",
      rm.sessionStorage.getSession("SessionRedirectSource") === "meds-preview-link" &&
      flag === "true"
        ? "true"
        : "false"
    );
  };

  var checkHistIfLatest = function checkHistIfLatest($elem) {
    if ($elem.index() < 1) {
      $(elemSelector.rmvBtnToolbar)
        .parent()
        .removeClass("hidden");
      showHideRmveBtn("hide");
      isFrstTr = true;
    } else {
      $(elemSelector.rmvBtnToolbar)
        .parent()
        .addClass("hidden");
      showHideRmveBtn("hide");
      isFrstTr = false;
    }
  };

  var showHideRmveBtn = function showHideRmveBtn(actionMode) {
	    if (actionMode === "hide") {
	      $("td.action > .btn-group").addClass("hidden");
	      $(".ShowHidePHSElem").addClass("hidden");
	        if(rm.sessionStorage.getSession("statusMode") === "restricted"){
				$(".toolbar-nav .btn__remove-phs").parent().addClass("hidden");
	        }
	    } else {
	      $("td.action > .btn-group").removeClass("hidden");
	      $(".ShowHidePHSElem").removeClass("hidden");
	    }
	  };

  var updateTableData = function updateTableData(data) {
    store.dispatch({ type: "FETCH_REMOTE_DATA" });
     store.dispatch({
          type: "ALLERGY_TABLE_INIT",
          items: data.allergiesItems.map(function(item) {
            item.status = "saved";
            return item;
          })
        });

        store.dispatch({
          type: "MEDICATION_TABLE_INIT",
          items: data.medicineItems.map(function(item) {
            item.status = "saved";
            return item;
          })
        });
    store.dispatch({ type: "FETCH_REMOTE_DATA_SUCCESS", payload: data });
  };

  var getHistoryData = function getHistoryData(_ref4) {
    var url = _ref4.url,
      _ref4$type = _ref4.type,
      type = _ref4$type === undefined ? "get" : _ref4$type,
      docid = _ref4.docid,
      repoid = _ref4.repoid,
      mode = _ref4.mode;

    var defer = $.Deferred();
    var ajaxConfig = void 0;
    if (mode === "history")
      ajaxConfig = {
        url: url,
        type: type,
        data: {
          repoId: repoid,
          documentId: docid
        },
        beforeSend: function() {
          if($('*[name="radio-buttons]"').length !== 0) $('*[name="radio-buttons"]').attr('disabled','disabled');
        },
        success: function success(response) {
          if($('*[name="radio-buttons"]').length !== 0) {
            $('*[name="radio-buttons"]').removeAttr('disabled');
            $('*[name="radio-buttons"]:checked').focus();
          }
          if (response == null) {
            return defer.reject("DOCLIST_NULL");
          }
          return defer.resolve(JSON.parse(response));
        },
        error: defer.reject
      };
    else {
      ajaxConfig = {
        url: url,
        type: type,
        success: function success(response) {
          if (response == null) {
            return defer.reject("DOCLIST_NULL");
          }
          return defer.resolve(JSON.parse(response));
        },
        error: defer.reject
      };
    }

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  $(".btn__access").on("click", function(e) {
    if ($(".btn__access").attr("data-mode") === "show") {
      $("td.action > .btn-group").removeClass("hidden");
    } else {
      $("td.action > .btn-group").addClass("hidden");
    }
  });

  $(".js-btn-cancel-remove-phs").on("click", function(e) {
    showHideRmveBtn();
  });
})(jQuery, Redux);

/* jshint ignore:end */
"use strict";

var _extends =
  Object.assign ||
  function(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];
      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }
    return target;
  };

function _toConsumableArray(arr) {
  if (Array.isArray(arr)) {
    for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) {
      arr2[i] = arr[i];
    }
    return arr2;
  } else {
    return Array.from(arr);
  }
}

/* jshint ignore:start */

(function($, Redux) {
  if ($("section.achievement-diary").length === 0) return;

  var createStore = Redux.createStore,
    combineReducers = Redux.combineReducers;

  // Reducers

  var AchievementTableDataReducer = function AchievementTableDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "ACHIEVEMENT_TABLE_ADD":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "ACHIEVEMENT_TABLE_UPDATE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ACHIEVEMENT_TABLE_REMOVE":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ACHIEVEMENT_TABLE_INIT":
        return actions.items;
      default:
        return state;
    }
  };

  var AchievementFormReducer = function AchievementFormReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var actions = arguments[1];

    switch (actions.type) {
      case "ACHIEVEMENT_FORM_ADD_SECTION":
        return [].concat(_toConsumableArray(state), [
          {
            id: "",
            achievementDate: "",
            achievement: "",
            achievementdescription: ""
          }
        ]);
      case "ACHIEVEMENT_FORM_INSERT_SECTION":
        return [].concat(_toConsumableArray(state), [actions.item]);
      case "ACHIEVEMENT_FORM_UPDATE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          [actions.item],
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ACHIEVEMENT_FORM_REMOVE_SECTION":
        return [].concat(
          _toConsumableArray(state.slice(0, actions.index)),
          _toConsumableArray(state.slice(actions.index + 1))
        );
      case "ACHIEVEMENT_FORM_INIT":
        return [];
      default:
        return state;
    }
  };

  var AchievementModeReducer = function AchievementModeReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { mode: "" };
    var actions = arguments[1];

    switch (actions.type) {
      case "ACHIEVEMENT_ENTER_EDIT_MODE":
        return _extends({}, state, { mode: "edit" });
      case "ACHIEVEMENT_ENTER_ADD_MODE":
        return _extends({}, state, { mode: "add" });
      case "ACHIEVEMENT_ENTER_REMOVE_MODE":
        return _extends({}, state, { mode: "remove" });
      case "ACHIEVEMENT_ENTER_SAVE_MODE":
        return _extends({}, state, { mode: "save" });
      case "ACHIEVEMENT_ENTER_SAVE_REMOVE_MODE":
        return _extends({}, state, { mode: "save_remove" });
      case "ACHIEVEMENT_ENTER_CANCEL_REMOVE_MODE":
        return _extends({}, state, { mode: "cancel_remove" });
      case "ACHIEVEMENT_ENTER_INIT_MODE":
        return _extends({}, state, { mode: "" });
      default:
        return state;
    }
  };

  var ServerDataReducer = function ServerDataReducer() {
    var state =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { payload: { achievementItems: [] } };
    var actions = arguments[1];

    switch (actions.type) {
      case "FETCH_REMOTE_DATA":
        return _extends({}, state, { payload: {}, loading: true });
      case "FETCH_REMOTE_DATA_SUCCESS":
        return _extends({}, state, {
          payload: actions.payload,
          loading: false
        });
      case "FETCH_REMOTE_DATA_FAIL":
        return _extends({}, state, {
          payload: {},
          loading: false,
          error: actions.error
        });
      case "SUBMIT_DATA_TO_REMOTE":
        return _extends({}, state, {
          dataSent: actions.payload,
          loading: true
        });
      case "SUBMIT_DATA_TO_REMOTE_SUCCESS":
        return _extends({}, state, {
          loading: false,
          sucessReponse: actions.response
        });
      case "SUBMIT_DATA_TO_REMOTE_FAIL":
        return _extends({}, state, { loading: false, error: actions.error });
      default:
        return state;
    }
  };

  var rootReducer = combineReducers({
    achievementTable: AchievementTableDataReducer,
    achievementForm: AchievementFormReducer,
    achievementMode: AchievementModeReducer,
    server: ServerDataReducer
  });

  // store configuration

  var store = createStore(rootReducer);

  var handleChange = function handleChange() {
    var data = store.getState();

    $(".achievement-diary .ajax-loader").addClass("hidden");

    if (data.server.error && data.server.error !== "") {
      $("#main-content")
        .nextAll()
        .remove()
        .end()
        .after(error());
      return;
    }

    if (data.server.loading) {
      $(".ajax-loader--pha")
        .removeClass("hidden")
        .addClass("loader-active");
      // $('#achievement-diary-table').html('').append(spinnerTpl('Loading Achievement Diary'))
      return;
    }

    if (data.achievementTable.length > 0) {
      $("#achievement-diary-table")
        .html("")
        .append(
          renderAchievementTableContentTpl(
            data.achievementTable,
            data.achievementMode.mode
          )
        );
      $("#section-util").removeClass("section--no-margin");
    } else {
      $("#achievement-diary-table")
        .html("")
        .prepend(noDataTpl("No personal achievements recorded."));
      $(".toolbar")
        .closest(".section")
        .addClass("hidden");
      $(".toolbar-nav").addClass("hidden");
      $("#section-util").addClass("section--no-margin");
      if (data.achievementMode.mode === "add") {
        $("#achievement-diary-no-data").addClass("hidden");
      }
    }

    if (data.achievementForm.length > 0) {
      $("#achievement-diary-form .table-controls")
        .html("")
        .append(
          renderAchievementForm(data.achievementForm, data.achievementMode.mode)
        );
    } else {
      $("#achievement-diary-form .table-controls")
        .html("")
        .append(addButton());
    }
  };

  var unsubscribe = store.subscribe(handleChange);

  // templates

  var addButton = function addButton() {
    var config =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : { action: "add-achievement", text: "Add a Personal Achievement" };

    return (
      '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row action-control">\n              <div class="col-xs-12">\n                <button type="button" class="btn btn--primary btn-lg" data-action="' +
      config.action +
      '">\n                  ' +
      config.text +
      "\n                </button>\n              </div>\n            </div>\n          </div>\n        </div>\n    "
    );
  };

  var renderAchievementTableContentTpl = function renderAchievementTableContentTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var achievementMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var JCR =
      arguments.length > 2 && arguments[2] !== undefined
        ? arguments[2]
        : {
            date: "Observation date",
            achievement: "Achievement",
            description: "Description (optional)"
          };
    var tableCaption =
      arguments.length > 3 && arguments[3] !== undefined
        ? arguments[3]
        : $("#achievement-diaries h2").text();

    return (
      '\n        <table class="table--base js-tb-rows-to-lists">\n          <caption class="sr-only">' +
      tableCaption +
      '</caption>\n          <thead>\n            <tr>\n              <th class="date">' +
      JCR.date +
      '</th>\n              <th class="achievement">' +
      JCR.achievement +
      '</th>\n              <th class="description">' +
      JCR.description +
      "</th>\n              " +
      (achievementMode === "add"
        ? ""
        : '<th class="text-right action">Actions</th>') +
      "\n            </tr>\n          </thead>\n          <tbody>\n            " +
      achievementTableListTpl(props, achievementMode, JCR) +
      "\n          </tbody>\n        </table>\n    "
    );
  };

  var achievementTableListTpl = function achievementTableListTpl() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var achievementMode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";
    var JCR =
      arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};

    return props.reduce(function(acc, cur, index, arr) {
      var id = cur.id,
        achievement = cur.achievement,
        achievementDate = cur.achievementDate,
        achievementdescription = cur.achievementdescription,
        status = cur.status;

      return (
        "\n            " +
        acc +
        '\n            <tr class="' +
        status +
        '">\n              <td class="date" data-th="' +
        JCR.date +
        '">' +
        achievementDate +
        '</td>\n              <td class="achievement" data-th="' +
        JCR.achievement +
        '">' +
        achievement +
        '</td>\n              <td class="description" data-th="' +
        JCR.description +
        '">' +
        achievementdescription +
        "</td>\n              " +
        achievementActionsByStatus(achievementMode, status, id) +
        "\n            </tr>\n        "
      );
    }, "");
  };

  var achievementActionsByStatus = function achievementActionsByStatus(
    achievementMode,
    status,
    id
  ) {
    var $toolbarNav = $(".toolbar-nav");

    if (
      achievementMode === "add" ||
      achievementMode === "edit" ||
      achievementMode === "remove"
    ) {
      $toolbarNav.addClass("hidden");
    } else {
      $toolbarNav.removeClass("hidden");
    }

    if (status === "saved") {
      if (achievementMode === "add") {
        return "";
      }
      return (
        '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              ' +
        actionsByMode(achievementMode, id) +
        "\n            </div>\n           </td>\n           "
      );
    }

    if (status === "editing") {
      return (
        '\n          <td class="action">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-edit">Undo Edit</button>\n            </div>\n           </td>\n           '
      );
    }

    if (status === "removing") {
      return (
        '\n          <td class="action">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="undo-remove">Undo Remove</button>\n            </div>\n           </td>\n         '
      );
    }
    return "";
  };

  var actionsByMode = function actionsByMode(mode, id) {
    if (mode === "edit") {
      return (
        '\n            <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="edit">Edit</button>\n        '
      );
    }

    if (mode.indexOf("remove") !== -1) {
      return (
        '\n        <button type="button" class="btn-link internal-link" data-id="' +
        id +
        '" data-action="remove">Remove</button>\n        '
      );
    }

    return (
      '\n        <button type="button" class="btn-link internal-link" data-id="' +
      id +
      '" data-action="edit">Edit</button>\n              <button type="button" class="btn-link internal-link" data-id="' +
      id +
      '" data-action="remove">Remove</button>\n    '
    );
  };

  var spinnerTpl = function spinnerTpl() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "Saving your changes";

    return (
      '\n     <div class="ajax-loader__table">\n       <div class="loader-spinner loader-spinner__circle"></div>\n       <div class="ajax-loader__text">\n         <p>' +
      text +
      "</p>\n       </div>\n     </div>\n    "
    );
  };

  var renderAchievementForm = function renderAchievementForm() {
    var props =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
    var mode =
      arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "";

    var action = getActionText(mode);

    var button =
      mode === "add"
        ? '<div class="row">\n                <div class="col-xs-12">\n                    <button type="button" class="btn-link internal-link" data-action="add-achievement">Add another personal achievement</button>\n                </div>\n            </div>'
        : "";

    if (mode.indexOf("remove") !== -1) {
      return (
        '\n             <form>\n                <h2 id="achievement-diary-focus-content" class="focus-title">' +
        action +
        ' personal achievement</h2>\n                <p>All fields are required unless indicated as optional.</p>\n                <ul class="remove-list">\n                ' +
        renderAchievementRemoveList(props) +
        "\n                </ul>\n                " +
        submitButtonsTpl() +
        "\n            </form>\n        "
      );
    }

    if (mode === "save") {
      return "" + spinnerTpl();
    }

    return (
      '\n    <form class="js-validate sodirty fv-form fv-form-bootstrap dirtylisten">\n        <h2 id="achievement-diary-focus-content" tabindex="-1" class="focus-title">' +
      action +
      " personal achievement</h2>\n        <p>All fields are required unless indicated as optional.</p>\n        " +
      renderAchievementFormSectionList(props, mode) +
      '\n        <div class="buttons-group">\n            ' +
      button +
      "\n            " +
      submitButtonsTpl() +
      "\n        </div>\n    </form>\n    "
    );
  };

  var submitButtonsTpl = function submitButtonsTpl() {
    return '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row row-gutter-small-xs">\n              <div class="col-xs-6">\n                <input type="submit" class="btn btn--block btn--primary" value="Save">\n              </div>\n              <div class="col-xs-6">\n                <input type="reset" class="btn btn--block btn--secondary" value="Cancel">\n              </div>\n            </div>\n          </div>\n        </div>\n    ';
  };

  var renderAchievementFormSectionList = function renderAchievementFormSectionList(
    sections,
    mode
  ) {
    return sections.reduce(function(acc, cur, index, arr) {
      var achievementTitle =
        mode === "add"
          ? '\n            <button class="btn-link internal-link h5" data-action="remove-achievement" data-id="' +
            index +
            '">Remove personal achievement ' +
            (index + 1) +
            "</button>\n            "
          : "";
      var dateDay =
        mode === "add" && index === "-1"
          ? ""
          : moment(cur.achievementDate, "DD-MMM-YYYY").format("DD");
      var dateMonth =
        mode === "add" && index === "-1"
          ? ""
          : moment(cur.achievementDate, "DD-MMM-YYYY").format("MM");
      var dateYear =
        mode === "add" && index === "-1"
          ? ""
          : moment(cur.achievementDate, "DD-MMM-YYYY").format("YYYY");
      return (
        "\n            " +
        acc +
        '\n            <section class="record" data-achievement-diary-index="' +
        index +
        '" data-achievement-diary-id="' +
        cur.id +
        '">\n                <div class="achievement-diary-title-wrap"><h3 class="achievement-diary-title h4" tabindex="-1">Personal achievement ' + (index + 1) +'</h3>' + achievementTitle + '</div>\n                <div class="row">\n                    <div class="col-xs-12 col-md-6">\n                        <div class="form-group date">\n                          <fieldset class="form-field-date native-date form-group">\n                            <legend>Observation date</legend>\n                            <div class="row">\n                              <div class="col-xs-4 col-md-3">\n                                <label for="achievementdates-day' +
        index +
        '">\n                                  Day (DD)\n                                  <input class="form-control" id="achievementdates-day' +
        index +
        '" name="achievementdates-day[]" data-field-type="day" type="number" placeholder="DD" min="1" value="' +
        dateDay +
        '">\n                                </label>\n                              </div>\n                              <div class="col-xs-4 col-md-3">\n                                <label for="achievementdates-month' +
        index +
        '">\n                                  Month (MM)\n                                <input class="form-control" id="achievementdates-month' +
        index +
        '" name="achievementdates-month[]" data-field-type="month" type="number" placeholder="MM" min="1" value="' +
        dateMonth +
        '">\n                                </label>\n                              </div>\n                              <div class="col-xs-4 col-md-3">\n                                 <label for="achievementdates-year' +
        index +
        '">\n                                  Year (YYYY)\n                                <input class="form-control" id="achievementdates-year' +
        index +
        '" name="achievementdates-year[]" data-field-type="year" type="number" placeholder="YYYY" min="1900" value="' +
        dateYear +
        '">\n                                </label>\n                              </div>\n                            </div>\n                            <div class="row row--full-date">\n                              <div class="col-xs-12 col-md-12 col-full-date">\n                                <label for="achievementdates-full' +
        index +
        '">\n                                  <input class="invisible form-control date-range-hidden" id="achievementdates-full' +
        index +
        '" data-invalid-date="no" data-after-date="no" name="achievementdates-full[]">\n                                </label>\n                              </div>\n                            </div>\n                          </fieldset>\n                        </div>\n                        <div class="form-group achievement">\n                            <label for="achievement' +
        index +
        '" class="btn--block">Achievement\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="achievement' +
        index +
        '" class="form-control" name="achievements[]" value="' +
        cur.achievement +
        '">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group description">\n                            <label for="description' +
        index +
        '" class="btn--block">Description (optional)\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="text" id="description' +
        index +
        '" class="form-control" name="descriptions[]" value="' +
        cur.achievementdescription +
        '">\n                                </span>\n                            </label>\n                        </div>\n                    </div>\n                </div>\n            </section>\n        '
      );
    }, "");
  };

  var renderAchievementRemoveList = function renderAchievementRemoveList(
    items
  ) {
    return items.reduce(function(acc, cur, index, arr) {
      return (
        "\n            " +
        acc +
        '\n            <li data-index="' +
        cur.id +
        '">\n                ' +
        cur.achievement +
        " " +
        (cur.achievementdescription.length > 0
          ? "- " + cur.achievementdescription
          : "") +
        "\n            </li>\n        "
      );
    }, "");
  };

  var noDataTpl = function noDataTpl() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : "";

    return (
      '\n        <div id="achievement-diary-no-data">\n          <div class="alert alert--notification alert--border--sky-blue " role="alert" aria-describedby="alert-description">\n              <div class="alert__icon">\n                <span class="icon icon--sm icon--info-circle">\n                  <span class="sr-only">Alert Information</span>\n                  <span class="print__icon">\n                      <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                  </span>\n                </span>\n              </div>\n              <div class="alert__message ">\n                <div class="alert__message__content" id="alert-description">' +
      text +
      "</div>\n              </div>\n\n          </div>\n      </div>\n    "
    );
  };

  var error = function error() {
    var text =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "We are currently experiencing an intermittent problem in displaying this page. If you are seeing this message, please retry selecting the Achievement Diary or select another option from the navigation menu.";

    return (
      '\n        <div class="container">\n            <div class="alert alert--white  alert--border--red alert--notification">\n                <div class="alert__icon">\n                    <span class="icon icon--sm icon--error">\n                    <span class="sr-only">Alert Error</span>\n                          <span class="print__icon">\n                              <svg width="27" height="23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Error</title><defs><path d="M11.5 0L-2.3 23h27.6z"/></defs><g fill="none" fill-rule="evenodd"><g transform="translate(2)"><use fill="#1F6DB1" xlink:href="#a"/><use fill="#D0021B" xlink:href="#a"/></g><path d="M12.35 10.35h2.3v-2.3h-2.3v2.3zm0 9.2h2.3v-6.9h-2.3v6.9z" fill="#FFF"/></g></svg>\n                          </span>\n                    </span>\n                </div>\n                <div class="alert__message h5">\n                  <div class="alert__message__content"><p>' +
      text +
      "</p></div>\n\n                </div>\n            </div>\n        </div>\n    "
    );
  };

  var achievementModalContent = function achievementModalContent(mode, action) {
    var itemCount = store.getState().achievementForm.length;

    if (mode === "add") {
      return action === "cancel"
        ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the newly added Achievement</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : itemCount > 1
          ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve added new personal achievements</h2>\n            </div>\n            <div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        '
          : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve added a new personal achievement</h2>\n            </div>\n            <div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
    }

    if (mode === "edit") {
      return action === "cancel"
        ? '\n             <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all information entered</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve updated a personal achievement</h2>\n            </div>\n            <div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
    }

    if (mode.indexOf("remove") !== -1) {
      return action === "cancel"
        ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">All information marked for removal will be undone once you cancel</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure want to cancel the changes?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        '
        : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">Information you have marked for removal will be permanent</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to remove this information?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n\n        ';
    }

    return "\n\n    ";
  };

  // helpers

  var getActionText = function getActionText(mode) {
    if (mode === "add") return "Adding";
    if (mode === "edit") return "Editing";
    if (mode.indexOf("remove") !== -1) return "Remove";
    return "";
  };

  var achievementTableDoAction = function achievementTableDoAction(e, status) {
    e.preventDefault();
    status === "editing" &&
      store.dispatch({ type: "ACHIEVEMENT_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "ACHIEVEMENT_ENTER_REMOVE_MODE" });
      
    var $action = $(e.target);
    var id = $action.data("id");

    var tableData = store.getState().achievementTable;
    var formData = store.getState().achievementForm;

    var index = tableData
      .map(function(item) {
        return item.id;
      })
      .indexOf(id);
    var item = tableData[index];

    store.dispatch({ type: "ACHIEVEMENT_FORM_INSERT_SECTION", item: item });
    store.dispatch({
      type: "ACHIEVEMENT_TABLE_UPDATE",
      item: _extends({}, item, { status: status }),
      index: index
    });

    if('removing' === status) $('#achievement-diary-form').find('h2').attr('tabindex', -1).focus();
    if('editing' === status) $('#achievement-diary-form').find('h2').attr('tabindex', -1).focus();
  };

  var achievementTableUndoAction = function achievementTableUndoAction(
    e,
    status
  ) {
    status === "editing" &&
      store.dispatch({ type: "ACHIEVEMENT_ENTER_EDIT_MODE" });
    status === "removing" &&
      store.dispatch({ type: "ACHIEVEMENT_ENTER_REMOVING_MODE" });

    var $action = $(e.target);
    var $actioningRows = $("#achievement-diary-table table tr." + status);

    if ($actioningRows.length === 1) {
      store.dispatch({ type: "ACHIEVEMENT_ENTER_INIT_MODE" });
    }

    var id = $action.data("id");

    var tableData = store.getState().achievementTable;
    var formData = store.getState().achievementForm;

    var indexInTable = tableData
      .map(function(item) {
        return item.id;
      })
      .indexOf(id);

    var indexInForm = formData
      .map(function(item) {
        return item.id;
      })
      .indexOf(id);

    var tableItem = tableData[indexInTable];

    store.dispatch({
      type: "ACHIEVEMENT_FORM_REMOVE_SECTION",
      index: indexInForm
    });
    store.dispatch({
      type: "ACHIEVEMENT_TABLE_UPDATE",
      item: _extends({}, tableItem, { status: "saved" }),
      index: indexInTable
    });
  };

  var getDocListData = function getDocListData(_ref) {
    var url = _ref.url,
      _ref$type = _ref.type,
      type = _ref$type === undefined ? "get" : _ref$type,
      data = _ref.data;

    var defer = $.Deferred();
    var ajaxConfig = {
      url: url,
      type: type,
      data: {
        jsonObj: JSON.stringify({ docListValue: $("#rimDescription").val() })
      },
      success: function success(response) {
        if (response == null) {
          return defer.reject("DOCLIST_NULL");
        }
        var responseempty = response[0][0];
        var usertype = response[0][1];

        if (responseempty === true) {
          if (usertype === "NR") {
            return defer.reject("DOCLIST_EMPTY_WITH_NR");
          }
          return defer.reject("DOCLIST_EMPTY");
        }
        return defer.resolve(response);
      },
      error: defer.reject
    };
    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var getPHAData = function getPHAData(_ref2) {
    var url = _ref2.url,
      _ref2$type = _ref2.type,
      type = _ref2$type === undefined ? "get" : _ref2$type;

    var defer = $.Deferred();

    var ajaxConfig = {
      url: url,
      type: type,
      success: function success(response) {
        if (typeof response === "string") {
          if (
            response == null ||
            response == "PCEHR_ERROR_0005" ||
            response == "PCEHR_ERROR_DEFAULT" ||
            response == ""
          ) {
            return defer.reject("PHA_SERVER_ERROR");
          }

          return defer.resolve(JSON.parse(response));
        }

        return defer.resolve(response);
      },
      error: defer.reject
    };

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var fetchAllData = function fetchAllData(docListAjaxConfig, PHAAjaxConfig) {
    var defer = $.Deferred();
    getDocListData(docListAjaxConfig)
      .done(function(response) {
        getPHAData(PHAAjaxConfig)
          .done(defer.resolve)
          .fail(function(error) {
            if (error === "PHA_SERVER_ERROR") {
              var mockupData = {
                achievementItems: [],
                documentId: "",
                repositoryId: ""
              };
              defer.resolve(mockupData);
            } else {
              defer.reject(error);
            }
          });
      })
      .fail(function(error) {
        if (error === "DOCLIST_EMPTY") {
          var mockupData = {
            achievementItems: [],
            documentId: "",
            repositoryId: ""
          };
          defer.resolve(mockupData);
        } else if (error === "DOCLIST_EMPTY_WITH_NR") {
          $("#achievement-diary-table")
            .html("")
            .prepend(noDataTpl("No personal achievements recorded."));
            $(".achievement-diary .ajax-loader").addClass("hidden");
            $(".toolbar-nav").addClass("hidden");
        } else {
          defer.reject(error);
        }
      });

    return defer.promise();
  };

  var postToCDA = function postToCDA(_ref3) {
    var url = _ref3.url,
      data = _ref3.data,
      _ref3$type = _ref3.type,
      type = _ref3$type === undefined ? "post" : _ref3$type,
      _ref3$dataType = _ref3.dataType,
      dataType = _ref3$dataType === undefined ? "html" : _ref3$dataType;

    var defer = $.Deferred();

    var ajaxConfig = {
      url: url,
      type: type,
      data: data,
      dataType: dataType,
      success: function success(response) {
        if ("success" === $.trim(response) || "SUCCESS" === $.trim(response)) {
          return defer.resolve("CDA_SUCCESS");
        }

        return defer.reject("CDA_SERVER_ERROR");
      },
      error: defer.reject
    };

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  var submitDataToCDA = function submitDataToCDA() {
    var submitFromSection =
      arguments.length > 0 && arguments[0] !== undefined
        ? arguments[0]
        : "achievement";

    $(".ajax-loader--pha")
      .removeClass("hidden")
      .addClass("loader-active");

    var state = store.getState();

    var data = createPostDataToCDA(state, submitFromSection);

    store.dispatch({ type: "SUBMIT_DATA_TO_REMOTE", payload: data });

    var preparePostCDA = void 0;
    var itemCount =
      state.achievementTable.length - state.achievementForm.length;

    if (window.location.host.indexOf("localhost:3000") !== -1 || window.location.host.indexOf("10.0.2.2:3000") !== -1) {
      if (itemCount === 0 && state.achievementMode.mode === "save_remove") {
        preparePostCDA = postToCDA({
          url: "/js/data/removedocument.json",
          type: "get"
        });
      } else {
        preparePostCDA = postToCDA({
          url: "/js/data/cdaUpload.json",
          type: "get"
        });
      }
    } else {
      if (itemCount === 0 && state.achievementMode.mode === "save_remove") {
        preparePostCDA = postToCDA({ url: "/ncp/removedocument", data: data });
      } else {
        preparePostCDA = postToCDA({ url: "/ncp/cdaUpload", data: data });
      }
    }

    return preparePostCDA
      .done(function(message) {
        store.dispatch({
          type: "SUBMIT_DATA_TO_REMOTE_SUCCESS",
          successResponse: message
        });
        return message;
      })
      .fail(function(error) {
        store.dispatch({ type: "SUBMIT_DATA_TO_REMOTE_FAIL", error: error });
        return error;
      })
      .always(function() {
        $(".ajax-loader--pha")
          .addClass("hidden")
          .removeClass("loader-active");
      });
  };

  var createPostDataToCDA = function createPostDataToCDA(storeState) {
    var select =
      arguments.length > 1 && arguments[1] !== undefined
        ? arguments[1]
        : "achievement";
    var achievementForm = storeState.achievementForm,
      achievementTable = storeState.achievementTable,
      achievementMode = storeState.achievementMode,
      server = storeState.server;

    var reason = "Hide";

    var itemCount = achievementTable.length - achievementForm.length;

    var docDetails = {
      docType: "PHA",
      docId: server.payload.documentId,
      repoId: server.payload.repositoryId,
      action: "edit"
    };

    if (select === "achievement") {
      var achieveItemsList = getDataList(
        achievementForm,
        achievementTable,
        achievementMode.mode
      );
      docDetails.achieveItemsList = cleanDataList(achieveItemsList);
    } else {
      docDetails.achieveItemsList = prepareCDADataList(
        achievementTable,
        "none"
      );
    }

    var documentJson = encodeURIComponent(JSON.stringify(docDetails));

    if (itemCount === 0 && achievementMode.mode === "save_remove") {
      return "reason=" + reason;
    } else {
      return (
        "documentJson=" +
        documentJson +
        "&documentId=" +
        docDetails.docId +
        "&repositoryId=" +
        docDetails.repoId
      );
    }
  };

  var cleanDataList = function cleanDataList(list) {
    return list.map(function(item) {
      item.date =
        typeof item.achievementDate !== "undefined"
          ? item.achievementDate
          : item.date;
      delete item.achievementDate;
      item.description =
        typeof item.achievementdescription !== "undefined"
          ? item.achievementdescription
          : item.description;
      delete item.achievementdescription;

      return item;
    });
  };

  var prepareCDADataList = function prepareCDADataList(list) {
    var action =
      arguments.length > 1 && arguments[1] !== undefined
        ? arguments[1]
        : "none";

    return list.map(function(item) {
      var itemClone = JSON.parse(JSON.stringify(item));
      itemClone.action = action;

      itemClone.status && delete itemClone.status;

      return itemClone;
    });
  };

  var getDataList = function getDataList(formData, tableData, mode) {
    if (mode === "add") {
      return [].concat(
        _toConsumableArray(prepareCDADataList(tableData, "none")),
        _toConsumableArray(prepareCDADataList(formData, "new"))
      );
    }

    if (mode === "edit") {
      return [].concat(
        _toConsumableArray(
          tableData.map(function(item) {
            var tableItem = JSON.parse(JSON.stringify(item));

            if ("editing" === tableItem.status) {
              tableItem.action = "delete";
            } else {
              tableItem.action = "none";
            }

            tableItem.status && delete tableItem.status;

            return tableItem;
          })
        ),
        _toConsumableArray(
          formData.map(function(item) {
            var formItem = JSON.parse(JSON.stringify(item));
            formItem.action = "new";
            formItem.id = "";

            formItem.status && delete formItem.status;

            return formItem;
          })
        )
      );
    }

    if (mode.indexOf("remove") !== -1) {
      return tableData.map(function(item) {
        var tableItem = JSON.parse(JSON.stringify(item));

        if ("removing" === tableItem.status) {
          tableItem.action = "delete";
        } else {
          tableItem.action = "none";
        }

        tableItem.status && delete tableItem.status;

        return tableItem;
      });
    }
  };

  // App

  $(function() {
    store.dispatch({ type: "FETCH_REMOTE_DATA" });

    var host = window.location.host;

    var fetchDataPromise = void 0;
    var lastUpdateInfo = void 0;

    if (host.indexOf("localhost:3000") !== -1 || host.indexOf("10.0.2.2:3000") !== -1) {
      fetchDataPromise = fetchAllData(
        { url: "/js/data/getDocListData.json" },
        { url: "/js/data/getAchievementsDiary.json" }
      );
    } else {
      fetchDataPromise = fetchAllData(
        { url: "/ncp/getDocListData", type: "post" },
        { url: "/ncp/getAchievementsDiary", type: "post" }
      );
    }

    fetchDataPromise
      .done(function(data) {
        if (data.authorName !== undefined) {
          if (data.lastUpdateDate !== "") {
            lastUpdateInfo =
              "<p>Last updated by " +
              data.authorName +
              " on " +
              data.lastUpdateDate +
              "</p>";
          } else {
            lastUpdateInfo = "";
            $("#last-updated").addClass("hidden");
          }
          $(lastUpdateInfo).appendTo("#last-updated");
        } else {
          lastUpdateInfo = "";
          $("#last-updated").addClass("hidden");
        }

        store.dispatch({
          type: "ACHIEVEMENT_TABLE_INIT",
          items: data.achievementItems.map(function(item) {
            item.status = "saved";
            return item;
          })
        });
        store.dispatch({ type: "FETCH_REMOTE_DATA_SUCCESS", payload: data });

        var usertype = data.NRFlag;

        if (usertype === "NR") {
          $(".toolbar-nav > ul > li:nth-child(2)").addClass("hidden");
          $("#achievement-diary-form .action-control button").addClass(
            "hidden"
          );
          $('th.action').addClass('hidden');
          $("td.action > .btn-group").addClass("hidden");
        }
        
        if('false' === rm.sessionStorage.getSession('showAccessFormOnLoad') && 0 !== $('.toolbar-access').length && !$('.toolbar-access').hasClass('js-content--show') && 0 !== $('.btn__access').length) {
          $('.btn__access').trigger('click');
          rm.sessionStorage.removeSession('showAccessFormOnLoad'); 
        }
      })
      .fail(function(error) {
        store.dispatch({ type: "FETCH_REMOTE_DATA_FAIL", error: error });
      });
  });

  $("#achievement-diaries")
    .on("click", '[data-action="add-achievement"]', function(e) {
      e.preventDefault();
      store.dispatch({ type: "ACHIEVEMENT_ENTER_ADD_MODE" });
      store.dispatch({ type: "ACHIEVEMENT_FORM_ADD_SECTION" });
      var $sections = $("section[data-achievement-diary-index]");

      $('#achievement-diary-focus-content').focus();
    })
    .on("click", '[data-action="remove-achievement"]', function(e) {
      e.preventDefault();
      var $remove = $(e.target);
      store.dispatch({
        type: "ACHIEVEMENT_FORM_REMOVE_SECTION",
        index: $remove.data("id")
      });
      var $last = $("section[data-achievement-diary-index]").last();
      if ($last.length > 0) {
        $last.find(".achievement-diary-title").focus();
      } else {
        store.dispatch({ type: "ACHIEVEMENT_ENTER_INIT_MODE" });
      }
    })
    .on("input", function(e) {
      var $input = $(e.target);
      var $section = $input.closest(".record");
      var $form = $input.closest('form');
      var index = $section.data("achievement-diary-index");
      var id = $section.data("achievement-diary-id");
      var achievementDate = moment(
        $section.find('.date input[name="achievementdates-month[]"]').val() +
          "-" +
          $section.find('.date input[name="achievementdates-day[]"]').val() +
          "-" +
          $section.find('.date input[name="achievementdates-year[]"]').val(),
        "MM/DD/YYYY"
      ).format("DD-MMM-YYYY");
      var achievement = $section.find(".achievement input").val();
      var achievementdescription = $section.find(".description input").val();

      unsubscribe();
      store.dispatch({
        type: "ACHIEVEMENT_FORM_UPDATE_SECTION",
        item: {
          id: id,
          achievement: achievement,
          achievementDate: achievementDate,
          achievementdescription: achievementdescription
        },
        index: index
      });
      unsubscribe = store.subscribe(handleChange);

      if ($input.val() !== "") {
        $form.addClass("dirty");
      } else {
        $form.removeClass("dirty");
      }
    })
    .on("click", 'input[type="reset"]', function(e) {
      e.preventDefault();

      var mode = store.getState().achievementMode.mode;

      $("#achievement-diary-form-submit-modal .modal-content").html(
        achievementModalContent(mode, "cancel")
      );
      $("#achievement-diary-form-submit-modal").modal("show");

      if (-1 !== mode.indexOf("remove")) {
        store.dispatch({ type: "ACHIEVEMENT_ENTER_CANCEL_REMOVE_MODE" });
      }
    })
    .on("click", 'input[type="submit"]', function(e) {
      e.preventDefault();
      var $submit = $(e.target);
      var $form = $submit.closest("form");
      var $years = $form
        .find('input[name="achievementdates-year[]"]')
        .toArray();
      var $dateFull = $form
        .find('input[name="achievementdates-full[]"]')
        .toArray();
      var $months = $form
        .find('input[name="achievementdates-month[]"]')
        .toArray();
      var $days = $form.find('input[name="achievementdates-day[]"]').toArray();
      var validators = rm.validation.getValidators();
      var $tbDatas = store.getState().server.payload.achievementItems;
      var $tbDates = [];
      var argArray = [
        ["addField", "achievementdates-day[]", validators.dateDay],
        ["addField", "achievementdates-month[]", validators.dateMonth],
        ["addField", "achievementdates-year[]", validators.dateYear],
        ["addField", "achievementdates-full[]", validators.multipleHiddenDate],
        ["addField", "achievements[]", validators.required],
        ["addField", "achievements[]", validators.phaChar],
        ["addField", "achievements[]", validators.no_blacklistCharacters],
        ["addField", "descriptions[]", validators.max120char],
        ["addField", "descriptions[]", validators.no_blacklistCharacters],
        [
          "updateMessage",
          "achievements[]",
          "notEmpty",
          "Enter an achievement of 16 characters or less, using letters and numbers only."
        ],
        [
          "updateMessage",
          "achievements[]",
          "regexp",
          "Enter an achievement of 16 characters or less, using letters and numbers only."
        ],
        [
          "updateMessage",
          "descriptions[]",
          "regexp",
          "Enter a description using letters and numbers only."
        ]
      ];

      $form.on('submit', function(e) {
        e.preventDefault();
      });

      validationMultipleHiddenDate(
        $tbDatas,
        $dateFull,
        $years,
        $months,
        $days,
        $tbDates
      );

      rm.validation.customInit($form, argArray);
      if (rm.validation.isFormValid($form)) {
        var state = store.getState();

        var mode = state.achievementMode.mode;

        var formBtnAdd = $("#achievement-diary-form .action-control button");
        var formBtnSave = $('#achievement-diary-form input[type="submit"]');
        var formBtnCancel = $('#achievement-diary-form input[type="reset"]');

        $(formBtnAdd).addClass("hidden");
        $(formBtnSave).addClass("hidden");
        $(formBtnCancel).addClass("hidden");

        if (-1 !== mode.indexOf("remove")) {
          $("#achievement-diary-form-submit-modal .modal-content").html(
            achievementModalContent(mode, "submit")
          );
          $("#achievement-diary-form-submit-modal").modal("show");
          store.dispatch({ type: "ACHIEVEMENT_ENTER_SAVE_REMOVE_MODE" });
          return;
        }

        submitDataToCDA("achievement")
          .done(function(response) {
            store.dispatch({ type: "ACHIEVEMENT_ENTER_SAVE_MODE" });
            $("#achievement-diary-form-submit-modal .modal-content").html(
              achievementModalContent(mode, "submit")
            );
            $("#achievement-diary-form-submit-modal").modal("show");
          })
          .fail(function(error) {
            return console.log(error);
          });
      }

      updateMinValidationMessage(
        $form,
        $days,
        "achievementdates-day[]",
        "greaterThan",
        "Enter the day in the format DD, using numbers only with a value greater than 00 and less than 32."
      );
    });

  var updateMinValidationMessage = function updateMinValidationMessage(
    $form,
    $elementArray,
    elementName,
    validator,
    message
  ) {
    $elementArray.forEach(function(val, index) {
      if (val.validity.rangeUnderflow) {
        $form
          .data("formValidation")
          .updateMessage(elementName, validator, message);
      }
    });
  };

  var validationMultipleHiddenDate = function validationMultipleHiddenDate(
    $tbDatas,
    $dateFull,
    $years,
    $months,
    $days,
    $tbDates
  ) {
    $tbDatas.forEach(function(val, index) {
      $tbDates.push(val.date);
    });

    $years.forEach(function(val, index) {
      if (
        $months[index].value > 0 &&
        $months[index].value < 13 &&
        $days[index].value > 0 &&
        $days[index].value < 32 &&
        val.value.length === 4 &&
        moment("01/01/" + val.value, "DD/MM/YYYY").diff(
          moment("01/01/1900", "DD/MM/YYYY")
        ) >= 0
      ) {
        if (
          moment(
            $months[index].value + "-" + $days[index].value + "-" + val.value,
            "MM-DD-YYYY"
          ).format("DD-MMM-YYYY") !== "Invalid date"
        ) {
          var $date = moment(
            $months[index].value + "-" + $days[index].value + "-" + val.value,
            "MM-DD-YYYY"
          ).format("DD-MMM-YYYY");

          if (
            moment($date, "DD-MMM-YYYY").isAfter(
              moment(new Date(), "DD-MMM-YYYY")
            )
          ) {
            $($dateFull[index]).attr("data-after-date", "yes");
          } else {
            $($dateFull[index]).attr("data-after-date", "no");
          }

          $($dateFull[index]).attr("data-invalid-date", "no");
        } else {
          $($dateFull[index]).attr("data-after-date", "no");
          if(($days[index].value.length === 2 || $days[index].value.length === 1) &&
          ($months[index].value.length === 2 || $months[index].value.length === 1))
            $($dateFull[index]).attr("data-invalid-date", "yes");
        }
      } else {
        $($dateFull[index]).attr("data-after-date", "no");
        $($dateFull[index]).attr("data-invalid-date", "no");
      }
    });
  };

  $("#achievement-diary-table")
    .on("click", '[data-action="edit"]', function(e) {
      e.preventDefault();
      achievementTableDoAction(e, "editing");
    })
    .on("click", '[data-action="undo-edit"]', function(e) {
      e.preventDefault();
      achievementTableUndoAction(e, "editing");
    })
    .on("click", '[data-action="remove"]', function(e) {
      e.preventDefault();
      achievementTableDoAction(e, "removing");
    })
    .on("click", '[data-action="undo-remove"]', function(e) {
      e.preventDefault();
      achievementTableUndoAction(e, "removing");
    });
    
  $(document).on('click', '[data-action="remove-achievement"]', function() {
    var target = $('*[data-action="add-achievement"]').get(0);
    
    window.setTimeout(function() {
      target.focus();
    }, 0)
  });
  
  var yesBtn = false;
    
  $(document).on('click', '[data-action]', function() {
    var mode = $(this).attr('data-action');
      
    if(mode === 'undo-remove' || mode === 'undo-edit') {
      var dataId = $(this).attr('data-id');
      var target = $('[data-id="' + dataId + '"][data-action="' + mode.replace('undo-', '') + '"]').get(0);

      target.focus();
    }
    
    if(mode === 'edit' || mode === 'remove') {
      var dataId = $(this).attr('data-id');
      var table = $(this).parents('table').first();
    }
    
    var cancelReturn = false;
    
    $('#achievement-diary-form-submit-modal').on('shown.bs.modal', function() {
      $(this).attr('disable-return-focus', true);
      cancelReturn = false;
      $(this).find('.btn--primary').on('click', function() {
        cancelReturn = true;
      });
    }).on('hidden.bs.modal', function(e) {
        e.preventDefault();
        
        if(cancelReturn) {
          cancelReturn = false;
          
          switch(mode) {
            case 'edit' :
              var target = $('[data-id="' + dataId + '"]').not('*[data-action="remove"]').get(0);
              break;
              
            case 'remove':
              var target = $('[data-id="' + dataId + '"]').not('*[data-action="edit"]').get(0);
              break;
              
            case 'add-achievement':
              var target = $('*[data-action="add-achievement"]').get(0);
              break;
          }

        } else {
          var btnOrigin = (yesBtn) ?  '.btn--primary' : '.btn--secondary';
          target = $('#achievement-diary-form').find(btnOrigin).get(0);
        }
        
        if(target) focusEl(target);
        
      });
    
    function focusEl(el) {
      window.setTimeout(function() { //necessary if button is modified or recreated
        $(el).focus();
      }, 0);
    }
  });
  
  $('#achievement-diary-form').on('click','.btn--primary', function() {
    yesBtn = true;
  });
  
  $('#achievement-diary-form').on('click','.btn--secondary', function() {
    yesBtn = false;
  });

  $("#achievement-diary-form-submit-modal")
    .on("click", '[type="submit"]', function(e) {
      e.preventDefault();

      var state = store.getState();
      var $modalBtn = $(".modal-footer button");

      $modalBtn.addClass("disabled");

      if (state.achievementMode.mode === "save") {
        window.location.href = window.location.pathname;
        return;
      }

      if (state.achievementMode.mode === "save_remove") {
        submitDataToCDA("achievement").done(function(response) {
          window.location.href = window.location.pathname;
        });
        return;
      }

      store.dispatch({ type: "ACHIEVEMENT_FORM_INIT" });
      store.dispatch({ type: "ACHIEVEMENT_ENTER_INIT_MODE" });
      store.dispatch({
        type: "ACHIEVEMENT_TABLE_INIT",
        items: state.server.payload.achievementItems
      });
      $("#achievement-diary-form-submit-modal").modal("hide");
    })
    .on("click", '[type="reset"]', function(e) {
      e.preventDefault();
      var state = store.getState();
      var mode = state.achievementMode.mode;
      var $modalBtn = $(".modal-footer button");

      $modalBtn.addClass("disabled");

      $("#achievement-diary-form-submit-modal").modal("hide");
      
      if(mode === 'cancel_remove' || mode === 'add' || mode === 'edit') {
        $('#achievement-diary-form input[type="reset"]').focus();
      } else if(mode === 'save_remove') {
        $('#achievement-diary-form input[type="submit"]').focus();
      }

      var formBtnAdd = $("#achievement-diary-form .action-control button");
      var formBtnSave = $('#achievement-diary-form input[type="submit"]');
      var formBtnCancel = $('#achievement-diary-form input[type="reset"]');

      $(formBtnAdd).addClass("hidden");
      $(formBtnSave).removeClass("hidden");
      $(formBtnCancel).removeClass("hidden");
    });

  $(".btn__history").on("click", function(e) {
    var docid = "";
    var repoid = "";

    var firstTrChecked = $(
      '.toolbar-history table tbody > tr:first-child input[type="radio"]'
    );
    var historyCount = $(".toolbar-history table tbody > tr").length;

    if ($(".btn__history").attr("data-mode") !== "show") {
      $("#achievement-diary-form .action-control button").addClass("hidden");
      $("td.action > .btn-group").addClass("hidden");
      $("th.action").addClass("hidden");
    } else {
      if (firstTrChecked.is(":checked") === true || historyCount === 1) {
        $('.action .btn-group').removeClass('hidden');
        $('*[data-action="add-achievement"').removeClass('hidden evtToolBarDisabled disabled-block disabled');
        $('th.action').removeClass('hidden');
      }
    }
  });

  $(".toolbar-history table tbody").on("click", "tr", function(e) {
    e.preventDefault();
    var $that = $(this);
    var docid = $that.attr("data-docid").trim();
    var repoid = $that.attr("data-repoid").trim();

    getHistoryData({
      url: "/ncp/getAchievementsDiary",
      type: "post",
      docid: docid,
      repoid: repoid,
      mode: "history"
    })
      // getHistoryData({url:'js/data/getAchievementsDiary.json',type:'get'})
      .done(function(data) {
        updateTableData(data);
        $("#achievement-diary-form .action-control button").addClass("hidden");
        $("td.action > .btn-group").addClass("hidden");
        $("th.action").addClass("hidden");
      })
      .fail(function(error) {
        store.dispatch({ type: "FETCH_REMOTE_DATA_FAIL", error: error });
      });
  });

  var updateTableData = function updateTableData(data) {
    store.dispatch({ type: "FETCH_REMOTE_DATA" });
    store.dispatch({
      type: "ACHIEVEMENT_TABLE_INIT",
      items: data.achievementItems.map(function(item) {
        item.status = "saved";
        return item;
      })
    });
    store.dispatch({ type: "FETCH_REMOTE_DATA_SUCCESS", payload: data });
  };

  var getHistoryData = function getHistoryData(_ref4) {
    var url = _ref4.url,
      _ref4$type = _ref4.type,
      type = _ref4$type === undefined ? "get" : _ref4$type,
      docid = _ref4.docid,
      repoid = _ref4.repoid,
      mode = _ref4.mode;

    var defer = $.Deferred();
    var ajaxConfig = void 0;
    if (mode === "history")
      ajaxConfig = {
        url: url,
        type: type,
        data: {
          repoId: repoid,
          documentId: docid
        },
        beforeSend: function() {
          if($('*[name="radio-buttons"]').length !== 0) $('*[name="radio-buttons"]').attr('disabled','disabled');
        },
        success: function success(response) {
          if($('*[name="radio-buttons"]').length !== 0) {
            $('*[name="radio-buttons"]').removeAttr('disabled');
            $('*[name="radio-buttons"]:checked').focus();
          }
          if (response == null) {
            return defer.reject("DOCLIST_NULL");
          }
          return defer.resolve(JSON.parse(response));
        },
        error: defer.reject
      };
    else {
      ajaxConfig = {
        url: url,
        type: type,
        success: function success(response) {
          if (response == null) {
            return defer.reject("DOCLIST_NULL");
          }
          return defer.resolve(JSON.parse(response));
        },
        error: defer.reject
      };
    }

    $.ajax(ajaxConfig);

    return defer.promise();
  };

  $(".btn__access").on("click", function(e) {
    if ($(".btn__access").attr("data-mode") === "show") {
      $("#achievement-diary-form .action-control button").removeClass("hidden");
      $('th.action').removeClass('hidden');
      $("td.action > .btn-group").removeClass("hidden");
    } else {
      $("#achievement-diary-form .action-control button").addClass("hidden");
      $('th.action').addClass('hidden');
      $("td.action > .btn-group").addClass("hidden");
    }
  });
})(jQuery, Redux);

/* jshint ignore:end */
'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

/* jshint ignore:start */

(function ($, Redux, dateCalc, rmToolbar) {

    if ($('body.page--growth-chart').length === 0) return;

    var createStore = Redux.createStore,
        combineReducers = Redux.combineReducers;

    // Reducers

    var ObservationTableDataReducer = function ObservationTableDataReducer() {
        var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
        var actions = arguments[1];

        switch (actions.type) {
            case 'OBSERVATION_TABLE_ADD':
                return [].concat(state, [actions.item]);
            case 'OBSERVATION_TABLE_UPDATE':
                return [].concat(state.slice(0, actions.index), [actions.item], state.slice(actions.index + 1));
            case 'OBSERVATION_TABLE_REMOVE':
                return [].concat(state.slice(0, actions.index), state.slice(actions.index + 1));
            case 'OBSERVATION_TABLE_INIT':
                return actions.items;
            default:
                return state;
        }
    };

    var ObservationFormReducer = function ObservationFormReducer() {
        var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
        var actions = arguments[1];

        switch (actions.type) {
            case 'OBSERVATION_FORM_ADD_SECTION':
                return [].concat(state, [{ id: '', date: '', head: '', height: '', weight: '' }]);
            case 'OBSERVATION_FORM_INSERT_SECTION':
                return [].concat(state, [actions.item]);
            case 'OBSERVATION_FORM_UPDATE_SECTION':
                return [].concat(state.slice(0, actions.index), [actions.item], state.slice(actions.index + 1));
            case 'OBSERVATION_FORM_REMOVE_SECTION':
                return [].concat(state.slice(0, actions.index), state.slice(actions.index + 1));
            case 'OBSERVATION_FORM_INIT':
                return [];
            default:
                return state;
        }
    };

    var ObservationModeReducer = function ObservationModeReducer() {
        var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : { mode: '' };
        var actions = arguments[1];

        switch (actions.type) {
            case 'OBSERVATION_ENTER_EDIT_MODE':
                return _extends({}, state, { mode: 'edit' });
            case 'OBSERVATION_ENTER_ADD_MODE':
                return _extends({}, state, { mode: 'add' });
            case 'OBSERVATION_ENTER_REMOVE_MODE':
                return _extends({}, state, { mode: 'remove' });
            case 'OBSERVATION_ENTER_SAVE_MODE':
                return _extends({}, state, { mode: 'save' });
            case 'OBSERVATION_ENTER_INIT_MODE':
                return _extends({}, state, { mode: '' });
            default:
                return state;
        }
    };

    var ServerDataReducer = function ServerDataReducer() {
        var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : { payload: { tbData: [] } };
        var actions = arguments[1];

        switch (actions.type) {
            case 'FETCH_REMOTE_DATA':
                return _extends({}, state, { payload: {}, loading: true });
            case 'FETCH_REMOTE_DATA_SUCCESS':
                return _extends({}, state, { payload: actions.payload, loading: false });
            case 'FETCH_REMOTE_DATA_FAIL':
                return _extends({}, state, { payload: {}, loading: false, error: actions.error });
            case 'SUBMIT_DATA_TO_REMOTE':
                return _extends({}, state, { dataSent: actions.payload, loading: true });
            case 'SUBMIT_DATA_TO_REMOTE_SUCCESS':
                return _extends({}, state, { loading: false, sucessReponse: actions.response });
            case 'SUBMIT_DATA_TO_REMOTE_FAIL':
                return _extends({}, state, { loading: false, error: actions.error });
            default:
                return state;
        }
    };

    var rootReducer = combineReducers({
        observationTable: ObservationTableDataReducer,
        observationForm: ObservationFormReducer,
        observationMode: ObservationModeReducer,
        server: ServerDataReducer
    });

    // store configuration

    var store = createStore(rootReducer);

    var handleChange = function handleChange() {
        var data = store.getState();
        if (data.server.error && data.server.error !== '') {

            $('#main-content').nextAll().remove().end().after(error());
            return;
        }

        if (data.server.loading) {
            $('#observation-table').html('');
            //$('#observation-table').html('').append(spinnerTpl('loading Information on Personal Observations '))
            return;
        }

        if (data.observationTable.length > 0) {
            $('#observation-table').html('').append(renderObservationTableContentTpl(data.observationTable, data.observationMode.mode, data.server.payload.dob));
            rmToolbar.toggleBtns(true, true);
            $('.toolbar-nav').removeClass('hidden');
            $('.tbfm__form__chart-filter').removeClass('hidden');
        } else {
            $('#observation-table').html('').prepend(noDataTpl('No Personal Observations are available.'));
            $('.tbfm__msg--emt-chartjson').removeClass('hidden');
            $('.tbfm__msg--emt-chartjson').find('.alert__content').html('').prepend('No Growth Charts are currently available. Please add a Personal Observation to select a Growth Chart.');
            rmToolbar.toggleBtns(false);
            $('.toolbar').closest('.section').addClass('hidden');
            $('.toolbar-nav').addClass('hidden');
            $('.tbfm__form__chart-filter').addClass('hidden');
        }

        if (data.observationForm.length > 0) {
            $('#observation-form .table-controls').html('').append(renderObservationForm(data.observationForm, data.observationMode.mode));
            $('form').dirtyForms();
        } else {
            $('#observation-form .table-controls').html('').append(addButton());
        }
    };

    var unsubscribe = store.subscribe(handleChange);

    // templates

    var addButton = function addButton() {
        var config = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : { action: 'add-observation', text: 'Add New Observation' };

        return '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row action-control">\n              <div class="col-xs-12">\n                <button type="button" class="btn btn--primary btn-lg" data-action="' + config.action + '">\n                  ' + config.text + '\n                </button>\n              </div>\n            </div>\n          </div>\n        </div>\n    ';
    };

    var renderObservationTableContentTpl = function renderObservationTableContentTpl() {
        var props = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
        var observationMode = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
        var dob = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
        var JCR = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : JSON.parse($('#observationJRCData').val());

        return '\n        <table class="table--base js-tb-rows-to-lists">\n          <thead>\n            <tr>\n              <th class="observationDate">' + JCR.date + '</th>\n              <th class="hidden">' + JCR.ageMonths + '</th>\n              <th class="hidden">' + JCR.ageYears + '</th>\n              <th class="head-info">' + JCR.head + '</th>\n              <th class="height">' + JCR.height + '</th>\n              <th class="weight">' + JCR.weight + '</th>\n              <th class="hidden">' + JCR.bmi + '</th>\n              ' + (observationMode === 'add' ? '' : '<th class="action">Actions</th>') + '\n            </tr>\n          </thead>\n          <tbody>\n            ' + observationTableListTpl(props, observationMode, dob, JCR) + '\n          </tbody>\n        </table>\n    ';
    };

    var observationTableListTpl = function observationTableListTpl() {
        var props = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
        var observationMode = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
        var dob = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
        var JCR = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};

        return props.reduce(function (acc, cur, index, arr) {
            var id = cur.id,
                date = cur.date,
                dateTime = cur.dateTime,
                head = cur.head,
                height = cur.height,
                weight = cur.weight,
                status = cur.status;

            return '\n            ' + acc + '\n            <tr class="' + status + '">\n              <td class="observationDate" data-th="' + JCR.date + '">' + date + '</td>\n              <td class="hidden" data-th="' + JCR.ageMonths + '">' + (dateCalc.ageAndRange(date, dob).asMth === 0 ? 'Birth' : dateCalc.ageAndRange(date, dob).asMth) + '</td>\n              <td class="hidden" data-th="' + JCR.ageYears + '">' + dateCalc.ageAndRange(date, dob).asYrs + '</td>\n              <td class="head-info" data-th="' + JCR.head + '">' + head + '</td>\n              <td class="height" data-th="' + JCR.height + '">' + height + '</td>\n              <td class="weight" data-th="' + JCR.weight + '">' + weight + '</td>\n              <td class="hidden" data-th="' + JCR.bmi + '">' + dateCalc.bmi(parseFloat(weight, 10), parseFloat(height, 10) / 100) + '</th>\n              ' + observationActionsByStatus(observationMode, status, id) + '\n            </tr>\n        ';
        }, '');
    };

    var observationActionsByStatus = function observationActionsByStatus(observationMode, status, id) {
        if (status === 'saved') {
            if (observationMode === 'add') {
                return '';
            }
            return '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              ' + actionsByMode(observationMode, id) + '\n            </div>\n           </td>\n           ';
        }

        if (status === 'editing') {
            return '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' + id + '" data-action="undo-edit">Undo Edit</button>\n            </div>\n           </td>\n           ';
        }

        if (status === 'removing') {
            return '\n          <td class="action" data-th="Actions">\n            <div class="btn-group pull-right">\n              <button type="button" class="btn-link internal-link" data-id="' + id + '" data-action="undo-remove">Undo Remove</button>\n            </div>\n           </td>\n         ';
        }
        return '';
    };

    var actionsByMode = function actionsByMode(mode, id) {
        if (mode === 'edit') {
            return '';
        }

        if (mode === 'remove') {
            return '';
        }

        return '\n        <button type="button" class="btn-link internal-link" data-id="' + id + '" data-action="edit">Edit</button>\n              <button type="button" class="btn-link internal-link" data-id="' + id + '" data-action="remove">Remove</button>\n    ';
    };

    var spinnerTpl = function spinnerTpl() {
        var text = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'Saving your changes';

        return '\n     <div class="ajax-loader__table">\n       <div class="loader-spinner loader-spinner__circle"></div>\n       <div class="ajax-loader__text">\n         <p>' + text + '</p>\n       </div>\n     </div>\n    ';
    };

    var renderObservationForm = function renderObservationForm() {
        var props = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
        var mode = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';

        var action = getActionText(mode);

        var button = mode === 'add' ? '<div class="row">\n                <div class="col-xs-12">\n                    <button type="button" class="btn-link internal-link" data-action="add-observation">Add another Observation</button>\n                </div>\n            </div>' : '';

        if (mode === 'remove') {
            return '\n             <form>\n                <h2 id="observation-focus-content" tabindex="-1" class="focus-title">' + action + ' personal observation information</h2>\n                <ul class="remove-list">\n                ' + renderObservationRemoveList(props) + '\n                </ul>\n                ' + submitButtonsTpl() + '\n            </form>\n        ';
        }

        if (mode === 'save') {
            return '' + spinnerTpl();
        }

        return '\n    <form class="js-validate sodirty">\n        <h2 id="observation-focus-content" tabindex="-1" class="focus-title">' + action + ' Observation</h2>\n        <p>All fields are required unless indicated as optional.</p>\n        <div class="form-group">' + renderObservationFormSectionList(props, mode) + '</div>\n        <div class="buttons-group">\n            ' + button + '\n            ' + submitButtonsTpl() + '\n        </div>\n    </form>\n    ';
    };

    var submitButtonsTpl = function submitButtonsTpl() {
        return '\n        <div class="row">\n          <div class="col-xs-12 col-sm-6 col-md-5">\n            <div class="row row-gutter-small-xs">\n              <div class="col-xs-6">\n                <input type="submit" class="btn btn--block btn--primary" value="Save">\n              </div>\n              <div class="col-xs-6">\n                <input type="reset" class="btn btn--block btn--secondary" value="Cancel">\n              </div>\n            </div>\n          </div>\n        </div>\n    ';
    };

    var renderObservationFormSectionList = function renderObservationFormSectionList(sections, mode) {
        var JCR = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : JSON.parse($('#observationJRCData').val());


        return sections.reduce(function (acc, cur, index, arr) {
            var title = mode === 'add' ? '\n            <button class="btn-link internal-link h5" data-action="remove-observation" data-id="' + index + '">Remove observation ' + (index + 1) + '</button>\n            ' : '';

            return '\n            ' + acc + '\n            <section class="record" data-observation-index="' + index + '" data-observation-id="' + cur.id + '">\n                <h3 class="observation-title" tabindex="-1">Observation ' + (index + 1) + ' ' + title + '</h3>\n                <div class="row">\n                    <div class="col-xs-12 col-md-6">\n                        <div class="form-group observationDate">\n                                    <fieldset class="form-field-date native-date form-group" d="native-date-' + index + '">\n                                        <legend>' + JCR.date + '</legend>\n                                        <div class="row">\n                                            <div class="col-xs-4 col-md-3">\n                                                <label for="day' + index + '">\n                                                Day (DD)\n                                                <input class="form-control" id="day' + index + '" name="day[]" value="' + moment(cur.date, "DD-MMM-YYYY").format("DD") + '" data-field-type="day" type="number" pattern="[0-9]*" placeholder="DD" min="1">\n                                                </label>\n                                            </div>\n                                            <div class="col-xs-4 col-md-3">\n                                                <label for="month' + index + '">\n                                                Month (MM)\n                                                <input class="form-control" id="month' + index + '" name="month[]" value="' + moment(cur.date, "DD-MMM-YYYY").format("MM") + '" data-field-type="month" type="number" pattern="[0-9]*" placeholder="MM" min="1">\n                                                </label>\n                                            </div>\n                                            <div class="col-xs-4 col-md-3">\n                                                <label for="year' + index + '">\n                                                Year (YYYY)\n                                                <input class="form-control" id="year' + index + '" name="year[]" value="' + moment(cur.date, "DD-MMM-YYYY").format("YYYY") + '" data-field-type="year" type="number" pattern="[0-9]*" placeholder="YYYY" min="1900">\n                                                </label>\n                                            </div>\n                                        </div>\n                                        <div class="row">\n                                            <div class="col-xs-12 col-md-9">\n                                                <label for="date-full-date' + index + '">\n                                                    <input class="invisible form-control date-full-hidden" id="date-full-date' + index + '" data-invalid-date="no" data-duplicate-date="no" data-before-date="no" data-after-date="no" name="date-full-date[]" />\n                                                </label>\n                                            </div>\n                                        </div>\n                                    </fieldset>                                \n                        </div>\n<h4 id="heading-item'+ index + '">Measurements</h4><div><p>Please enter at least one measurement.</p><p class="custom-alert-message hidden"><small class="help-block" aria-labelledby="heading-item'+ index + '" role="alert" aria-live="assertive">Please enter a measurement for either head circumference, height or weight.</small></p></div><div class="form-group head">\n                            <label for="obsv-head-ccf' + index + '" class="btn--block">' + JCR.head + '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="number" id="obsv-head-ccf' + index + '" class="form-control" name="obsv-head-ccf[]" value="' + cur.head + '" data-fm-elem-src="obsv-head-ccf" data-oneof-required="" step=".1" min="0" max="9999.9" data-fv-field="obsv-head-ccf[]" data-field-type="float" placeholder="Enter head circumference in cm">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group height">\n                            <label for="obsv-height' + index + '" class="btn--block">' + JCR.height + '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="number" id="obsv-height' + index + '" class="form-control" name="obsv-height[]" value="' + cur.height + '" data-fm-elem-src="obsv-height" data-oneof-required="" step=".1" min="0" max="9999.9" data-fv-field="obsv-height[]" data-field-type="float" placeholder="Enter height in cm">\n                                </span>\n                            </label>\n                        </div>\n                        <div class="form-group weight">\n                            <label for="obsv-weight' + index + '" class="btn--block">' + JCR.weight + '\n                                <span class="validation-wrapper validation-wrapper--input">\n                                    <input type="number" id="obsv-weight' + index + '" class="form-control" name="obsv-weight[]" value="' + cur.weight + '" data-fm-elem-src="obsv-weight" data-oneof-required="" step=".001" min="0" max="9999.9" data-fv-field="obsv-weight[]" data-field-type="float" placeholder="Enter weight in kg">\n                                </span>\n                            </label>\n                        </div>\n                    </div>\n                </div>\n            </section>\n        ';
        }, '');
    };

    var renderObservationRemoveList = function renderObservationRemoveList(items) {

        return items.reduce(function (acc, cur, index, arr) {
            return '\n            ' + acc + '\n            <li data-index="' + cur.id + '">\n                Personal observation; Observation date ' + cur.date + (cur.head === "" ? "" : ", Head Circumference " + cur.head + "cm") + (cur.height === "" ? "" : ", Height " + cur.height + "cm") + (cur.weight === "" ? "" : ", Weight " + cur.weight + "kg") + '\n            </li>\n        ';
        }, '');
    };

    var noDataTpl = function noDataTpl() {
        var text = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

        return '\n        <div id="observations-no-data">\n          <div class="alert alert--notification alert--white alert--border--sky-blue " role="alert" aria-describedby="alert-description">\n              <div class="alert__icon">\n                <span class="icon icon--sm icon--info-circle">\n                  <span class="sr-only">Alert Information</span>\n                  <span class="print__icon">\n                      <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                  </span>\n                </span>\n              </div>\n              <div class="alert__message ">\n                <div class="alert__message__content" id="alert-description">' + text + '</div>\n              </div>\n\n          </div>\n      </div>\n    ';
    };

    var error = function error() {
        var text = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'We are currently experiencing an intermittent problem in displaying this page. If you are seeing this message, please retry selecting the Growth Chart or select another option from the navigation menu.';

        return '\n        <div class="container">\n            <div class="alert alert--white  alert--border--red alert--notification">\n                <div class="alert__icon">\n                    <span class="icon icon--sm icon--error">\n                    <span class="sr-only">Alert Error</span>\n                          <span class="print__icon">\n                              <svg width="27" height="23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Error</title><defs><path d="M11.5 0L-2.3 23h27.6z"/></defs><g fill="none" fill-rule="evenodd"><g transform="translate(2)"><use fill="#1F6DB1" xlink:href="#a"/><use fill="#D0021B" xlink:href="#a"/></g><path d="M12.35 10.35h2.3v-2.3h-2.3v2.3zm0 9.2h2.3v-6.9h-2.3v6.9z" fill="#FFF"/></g></svg>\n                          </span>\n                    </span>\n                </div>\n                <div class="alert__message h5">\n                  <div class="alert__message__content"><p>' + text + '</p></div>\n\n                </div>\n            </div>\n        </div>\n    ';
    };

    var observationModalContent = function observationModalContent(mode, action) {

        if (mode === 'add') {
            return action === 'cancel' ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the information entered</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        ' : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve added a new personal observation</h2>\n            </div><div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
        }

        if (mode === 'add-multiple') {
            return action === 'cancel' ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the newly added observation</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        ' : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve added new personal observations</h2>\n            </div><div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
        }

        if (mode === 'edit') {
            return action === 'cancel' ? '\n             <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You will lose all the information entered</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to cancel?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        ' : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">You\'ve updated a personal observation</h2>\n            </div><div class="modal-body"><p>Please select Ok to continue.</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Ok</button>\n            </div>\n        ';
        }

        if (mode === 'remove') {
            return action === 'cancel' ? '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">All observation information marked for removal will be undone once you cancel</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure want to cancel the changes?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary" data-cancel="cancel">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n        ' : '\n            <div class="modal-header">\n              <h2 class="modal-title h4" id="form-submit-modal">Information you have marked for removal will be permanent</h2>\n            </div>\n            <div class="modal-body"><p>Are you sure you want to remove this information?</p></div>\n            <div class="modal-footer">\n              <button type="submit" class="btn btn--primary">Yes</button>\n              <button type="reset" class="btn btn--secondary" data-dismiss="modal">No</button>\n            </div>\n\n        ';
        }

        return '\n\n    ';
    };

    // helpers

    var getActionText = function getActionText(mode) {
        if (mode === 'add') return 'Add';
        if (mode === 'edit') return 'Editing';
        if (mode === 'remove') return 'Remove';
        return '';
    };

    var observationTableDoAction = function observationTableDoAction(e, status) {

        status === 'editing' && store.dispatch({ type: 'OBSERVATION_ENTER_EDIT_MODE' });
        status === 'removing' && store.dispatch({ type: 'OBSERVATION_ENTER_REMOVE_MODE' });

        var $action = $(e.target);
        var id = $action.data('id');

        var tableData = store.getState().observationTable;
        var formData = store.getState().observationForm;

        var index = tableData.map(function (item) {
            return item.id;
        }).indexOf(id);
        var item = tableData[index];

        store.dispatch({ type: 'OBSERVATION_FORM_INSERT_SECTION', item: item });
        store.dispatch({ type: 'OBSERVATION_TABLE_UPDATE', item: _extends({}, item, { status: status }), index: index });

        $('#observation-focus-content').focus();
    };

    var observationTableUndoAction = function observationTableUndoAction(e, status) {

        status === 'editing' && store.dispatch({ type: 'OBSERVATION_ENTER_EDIT_MODE' });
        status === 'removing' && store.dispatch({ type: 'OBSERVATION_ENTER_REMOVING_MODE' });

        var $action = $(e.target);
        var $actioningRows = $('#observation-table table tr.' + status);

        if ($actioningRows.length === 1) {
            store.dispatch({ type: 'OBSERVATION_ENTER_INIT_MODE' });
        }

        var id = $action.data('id');

        var tableData = store.getState().observationTable;
        var formData = store.getState().observationForm;

        var indexInTable = tableData.map(function (item) {
            return item.id;
        }).indexOf(id);
        var indexInForm = formData.map(function (item) {
            return item.id;
        }).indexOf(id);
        var tableItem = tableData[indexInTable];

        store.dispatch({ type: 'OBSERVATION_FORM_REMOVE_SECTION', index: indexInForm });
        store.dispatch({ type: 'OBSERVATION_TABLE_UPDATE', item: _extends({}, tableItem, { status: 'saved' }), index: indexInTable });
    };

    var getDocListData = function getDocListData(_ref) {
        var url = _ref.url,
            _ref$type = _ref.type,
            type = _ref$type === undefined ? 'get' : _ref$type,
            data = _ref.data;

        var defer = $.Deferred();
        var ajaxConfig = {
            url: url,
            type: type,
            data: {
                jsonObj: JSON.stringify({ docListValue: $('#rimDescription').val() })
            },
            success: function success(response) {
                if (response == null) {
                    return defer.reject('DOCLIST_NULL');
                }

                var usertype = void 0;
                var usertype2 = void 0;

                if (typeof response[0][1] !== 'undefined') {
                    usertype = response[0][1];
                }
                if (typeof response[0][6] !== 'undefined') {
                    usertype2 = response[0][6];
                }

                if (usertype === 'NR' || usertype2 === 'NR') {
                    if (usertype === 'NR') {
                        $('#rimDescription').attr('data-type', usertype);
                    }
                    if (usertype2 === 'NR') {
                        $('#rimDescription').attr('data-type', usertype2);
                    }
                }
                return defer.resolve(response);
            },
            error: defer.reject
        };
        $.ajax(ajaxConfig);

        return defer.promise();
    };

    var getPHSData = function getPHSData(_ref2) {
        var url = _ref2.url,
            _ref2$type = _ref2.type,
            type = _ref2$type === undefined ? 'get' : _ref2$type;

        var defer = $.Deferred();

        var ajaxConfig = {
            url: url,
            type: type,
            success: function success(response) {
                var showAccessFormOnLoad = rm.sessionStorage.getSession('showAccessFormOnLoad');
                
                if('true' === showAccessFormOnLoad && 0 !==  $(".btn__access").length) {
                  $(".btn__access").trigger('click');
                  rm.sessionStorage.removeSession('showAccessFormOnLoad');
                }

                if (typeof response === 'string') {
                    if (response == null || response == 'PCEHR_ERROR_0005' || response == 'PCEHR_ERROR_DEFAULT' || response == '') {
                        return defer.reject('PHS_SERVER_ERROR');
                    }

                    return defer.resolve(JSON.parse(response));
                }

                return defer.resolve(response);
            },
            error: defer.reject
        };

        $.ajax(ajaxConfig);

        return defer.promise();
    };

    var fetchAllData = function fetchAllData(docListAjaxConfig, PHSAjaxConfig) {
        var defer = $.Deferred();
        getDocListData(docListAjaxConfig).done(function (response) {
            getPHSData(PHSAjaxConfig).done(defer.resolve).fail(defer.reject);
        }).fail(defer.reject);

        return defer.promise();
    };

    var postToCDA = function postToCDA(_ref3) {
        var url = _ref3.url,
            data = _ref3.data,
            _ref3$type = _ref3.type,
            type = _ref3$type === undefined ? 'post' : _ref3$type,
            _ref3$dataType = _ref3.dataType,
            dataType = _ref3$dataType === undefined ? 'html' : _ref3$dataType;

        var defer = $.Deferred();

        var ajaxConfig = {
            url: url,
            type: type,
            data: data,
            dataType: dataType,
            success: function success(response) {
                if ('SUCCESS' === $.trim(response) || 'success' === $.trim(response)) {
                    return defer.resolve('CDA_SUCCESS');
                }

                return defer.reject('CDA_SERVER_ERROR');
            },
            error: defer.reject
        };

        $.ajax(ajaxConfig);

        return defer.promise();
    };

    var submitDataToCDA = function submitDataToCDA() {
        var submitFromSection = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

        showWrapLoader($(".ajax-loader"));
        var state = store.getState();
        var urlLink = {
            link: '/ncp/cdaUpload'
        };

        var data = createPostDataToCDA(state, submitFromSection);

        store.dispatch({ type: 'SUBMIT_DATA_TO_REMOTE', payload: data });

        if (state.observationTable.length === 1 && state.observationMode.mode === 'remove') {
            urlLink.link = '/ncp/removedocument';
        }

        return postToCDA({ url: urlLink.link, data: data }).done(function (message) {
            store.dispatch({ type: 'SUBMIT_DATA_TO_REMOTE_SUCCESS', successResponse: message });
            return message;
        }).fail(function (error) {
            store.dispatch({ type: 'SUBMIT_DATA_TO_REMOTE_FAIL', error: error });
            return error;
        }).always(function () {
            hideWrapLoader($(".ajax-loader"));
        });
    };

    var createPostDataToCDA = function createPostDataToCDA(storeState) {
        var select = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
        var observationForm = storeState.observationForm,
            observationTable = storeState.observationTable,
            observationMode = storeState.observationMode,
            server = storeState.server;

        var reason = 'Hide';
        if (observationMode.mode === 'remove' && observationTable.length === 1) {
            return 'documentUniqueId=' + server.payload.docId + '&repositoryId=' + server.payload.repoId + '&reason=' + reason;
        } else {
            var docDetails = {
                docType: 'PHO',
                docId: server.payload.docId,
                repoId: server.payload.repoId,
                action: getActionByMode(observationMode.mode),
                currEntryId: getCurrentEntryID(observationForm, observationMode.mode)
                //docDetails.tbData = getDataList(observationForm, observationTable, observationMode.mode)
            };docDetails.fmData = getFormDataList(observationForm, observationMode.mode);
            docDetails.tbData = getTableDataList(observationTable, observationMode.mode);

            var documentJson = encodeURIComponent(JSON.stringify(docDetails));
            if (observationMode.mode === 'add' && observationTable.length === 0) {
                return 'documentJson=' + documentJson;
            } else {
                return 'documentJson=' + documentJson + '&documentId=' + docDetails.docId + '&repositoryId=' + docDetails.repoId;
            }
        }
    };

    var getCurrentEntryID = function getCurrentEntryID(formData, mode) {
        switch (mode) {
            case 'add':
                return 'false';
            case 'edit':
            case 'remove':
                return getEntryID(formData);
            default:
                return 'false';
        }
    };

    var getEntryID = function getEntryID(formData) {
        //enable only once confirmed if multiple removal of entry is confirmed
        //return formData.map( item => {
        //            const itemClone = JSON.parse(JSON.stringify(item))
        //            return itemClone.id
        //        })
        return formData[0].id;
    };

    var getActionByMode = function getActionByMode() {
        var mode = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'none';

        switch (mode) {
            case 'add':
            case 'edit':
                return mode;
            case 'remove':
                return 'del';
            default:
                return 'false';
        }
    };

    var prepareCDADataList = function prepareCDADataList(list) {
        var action = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'none';

        return list.map(function (item) {
            var itemClone = JSON.parse(JSON.stringify(item));
            itemClone.action = action;

            itemClone.status && delete itemClone.status;

            return itemClone;
        });
    };

    var getFormDataList = function getFormDataList(formData, mode) {
        switch (mode) {
            case 'add':
            case 'edit':
                return [].concat(prepareFormDataList(formData));
            case 'remove':
                return 'false';
            default:
                return 'false';
        }
    };

    var getTableDataList = function getTableDataList(tableData, mode) {
        return [].concat(prepareTableDataList(tableData));
    };

    var prepareFormDataList = function prepareFormDataList(list) {
        return list.map(function (item) {
            var itemClone = JSON.parse(JSON.stringify(item));
            delete itemClone.id;
            return itemClone;
        });
    };

    var prepareTableDataList = function prepareTableDataList(list) {
        return list.map(function (item) {
            var itemClone = JSON.parse(JSON.stringify(item));
            delete itemClone.status;
            return itemClone;
        });
    };

    var getDataList = function getDataList(formData, tableData, mode) {
        if (mode === 'add') {
            return [].concat(prepareCDADataList(tableData, 'none'), prepareCDADataList(formData, 'new'));
        }

        if (mode === 'edit') {
            return [].concat(tableData.map(function (item) {

                var tableItem = JSON.parse(JSON.stringify(item));

                if ('editing' === tableItem.status) {
                    tableItem.action = 'delete';
                } else {
                    tableItem.action = 'none';
                }

                tableItem.status && delete tableItem.status;

                return tableItem;
            }), formData.map(function (item) {

                var formItem = JSON.parse(JSON.stringify(item));
                formItem.action = 'new';
                formItem.id = '';

                formItem.status && delete formItem.status;

                return formItem;
            }));
        }

        if (mode === 'remove') {
            return tableData.map(function (item) {

                var tableItem = JSON.parse(JSON.stringify(item));

                if ('removing' === tableItem.status) {
                    tableItem.action = 'delete';
                } else {
                    tableItem.action = 'none';
                }

                tableItem.status && delete tableItem.status;

                return tableItem;
            });
        }
    };

    // App

    $(function () {
        showWrapLoader($(".ajax-loader"));
        store.dispatch({ type: 'FETCH_REMOTE_DATA' });

        var host = window.location.host;

        var fetchDataPromise = void 0;

        if (host.indexOf('localhost:3000') !== -1 || host.indexOf('10.0.2.2:3000') !== -1) {
            fetchDataPromise = fetchAllData({ url: '/js/data/getDocListTestData.json' }, { url: '/js/data/table-form_table-data.json' }); ///js/data/table-form_table-data.json, /js/data/getHealthObservation.json
        } else {
            fetchDataPromise = fetchAllData({ url: '/ncp/getDocListData', type: 'post' }, { url: '/ncp/getHealthObservation', type: 'get' });
        }
        $('#select-chart-type').val('');
        fetchDataPromise.done(function (data) {
            store.dispatch({
                type: 'OBSERVATION_TABLE_INIT',
                items: data.tbData.map(function (item) {
                    item.status = 'saved';
                    return item;
                })
            });

            if (data.lastUpdated !== undefined) {
                if (data.lastUpdated !== '') {
                    lastUpdateInfo = '<p>' + data.lastUpdated + '</p>';
                } else {
                    lastUpdateInfo = '';
                    $('#last-updated').addClass('hidden');
                }
                $(lastUpdateInfo).appendTo("#last-updated");
            } else {
                lastUpdateInfo = '';
                $('#last-updated').addClass('hidden');
            }

            store.dispatch({ type: 'FETCH_REMOTE_DATA_SUCCESS', payload: data });
            hideButtonsAndColumns();
            
            if($(document.body).hasClass('access-form-shown') && 0 !== $('.toolbar-access').length && $('.toolbar-access').hasClass('hidden') && 0 !== $('.btn__access').length) {
              $('.btn__access').attr('data-mode','show').trigger('click').trigger('click');
            }
        }).fail(function (error) {
            store.dispatch({ type: 'FETCH_REMOTE_DATA_FAIL', error: error });
            console.log(error);
        }).always(function () {
            hideWrapLoader($(".ajax-loader"));
        });
    });

    $('#current-observations-section').on('click', '[data-action="add-observation"]', function (e) {
        e.preventDefault();
        hideElementClass($('.section--growth-chart'));
        store.dispatch({ type: 'OBSERVATION_ENTER_ADD_MODE' });
        store.dispatch({ type: 'OBSERVATION_FORM_ADD_SECTION' });
        $('#observations-no-data').remove();
        var $sections = $('section[data-observation-index]');

        if ($sections.length > 1) {
            $sections.last().find('.observation-title').focus();
        } else {
            $('#observation-focus-content').focus();
        }
        $('.toolbar-nav').addClass('hidden');
    }).on('click', '[data-action="remove-observation"]', function (e) {
        e.preventDefault();
        var $remove = $(e.target);
        store.dispatch({ type: 'OBSERVATION_FORM_REMOVE_SECTION', index: $remove.data('id') });
        var $last = $('section[data-observation-index]').last();

        if ($last.length > 0) {
            $last.find('.observation-title').focus();
        } else {
            showElementClass($('.section--growth-chart'));
            store.dispatch({ type: 'OBSERVATION_ENTER_INIT_MODE' });
        }
    }).on('input', function (e) {
        var $input = $(e.target);
        var $section = $input.closest('.record');
        var index = $section.data('observation-index');
        var id = $section.data('observation-id');
        var date = moment($section.find('.observationDate input[name="day[]"]').val() + '-' + $section.find('.observationDate input[name="month[]"]').val() + '-' + $section.find('.observationDate input[name="year[]"]').val(), 'DD/MM/YYYY').format('DD-MMM-YYYY');
        var head = $section.find('.head input').val();
        var height = $section.find('.height input').val();
        var weight = $section.find('.weight input').val();

        unsubscribe();
        store.dispatch({ type: 'OBSERVATION_FORM_UPDATE_SECTION', item: { id: id, date: date, head: head, height: height, weight: weight }, index: index });
        unsubscribe = store.subscribe(handleChange);
    }).on('click', 'input[type="reset"]', function (e) {
        e.preventDefault();
        if ($('.btn.btn--secondary').attr('data-dismiss') === 'modal') {
            hideElementClass($('.section--growth-chart'));
        }
        var state = store.getState();

        $('#observation-form-submit-modal .modal-content').html(observationModalContent(state.observationMode.mode, 'cancel'));
        $('#observation-form-submit-modal').modal('show');
    }).on('click', 'input[type="submit"]', function (e) {
        e.preventDefault();
        var $submit = $(e.target);
        var $form = $submit.closest('form');
        var $years = $form.find('input[name="year[]"]').toArray();
        var $dateFull = $form.find('input[name="date-full-date[]"]').toArray();
        var $months = $form.find('input[name="month[]"]').toArray();
        var $days = $form.find('input[name="day[]"]').toArray();
        var validators = rm.validation.getValidators();
        var $tbDatas = store.getState().server.payload.tbData;
        var dob = store.getState().server.payload.dob;
        var fullname = store.getState().server.payload.fullName;
        var $tbDates = [];
        var argArray = [['addField', 'day[]', validators.dateDay],
                        ['addField', 'month[]', validators.dateMonth],
                        ['addField', 'year[]', validators.dateYear],
                        ['addField', 'date-full-date[]', validators.duplicateEntryOrBeforeDate],
                        ['addField', 'obsv-head-ccf[]', validators.provideOne],
                        ['addField', 'obsv-height[]', validators.provideOne],
                        ['addField', 'obsv-weight[]', validators.provideOne],
                        ['addField', 'obsv-head-ccf[]', validators.headHeightDecimal],
                        ['addField', 'obsv-height[]', validators.headHeightDecimal],
                        ['addField', 'obsv-weight[]', validators.weightDecimal]];

        validationDuplicateAndBeforeDate($tbDatas, $dateFull, $years, $months, $days, dob, fullname, $tbDates);

        rm.validation.customInit($form, argArray);
        $form.on('submit', function (e) {
            e.preventDefault();
        });
        if (rm.validation.isFormValid($form)) {
            var state = store.getState();
            var mode = state.observationMode.mode;

            $('.btn--primary').addClass('hidden');
            $('.btn--secondary').addClass('hidden');

            var data = createPostDataToCDA(state, 'observation');

            if ('remove' === mode) {
                $('#observation-form-submit-modal .modal-content').html(observationModalContent(mode, 'submit'));
                $('#observation-form-submit-modal').modal('show');
                $('.btn--primary').removeClass('hidden');
                $('.btn--secondary').removeClass('hidden');
                return;
            }

            submitDataToCDA('observation').done(function (response) {
                store.dispatch({ type: 'OBSERVATION_ENTER_SAVE_MODE' });
                if(mode === 'add' && state.observationForm.length > 1){
                    $('#observation-form-submit-modal .modal-content').html(observationModalContent(mode+'-multiple', 'submit'));
                }
                else{
                    $('#observation-form-submit-modal .modal-content').html(observationModalContent(mode, 'submit'));
                }
                $('#observation-form-submit-modal').modal('show');
                hideWrapLoader($(".ajax-loader"));
            }).fail(function (error) {
                return console.log(error);
            });
        }

        updateMinValidationMessage($form, $years, 'year[]', 'greaterThan', 'Enter the year in the format YYYY, using numbers only with a value greater than or equal to 1900.');
        updateMinValidationMessage($form, $days, 'day[]', 'greaterThan', 'Enter the day in the format DD, using numbers only with a value greater than 00 and less than 32.');
    });

    $('#observation-form').on('input','[data-fv-field="obsv-head-ccf[]"],[data-fv-field="obsv-height[]"],[data-fv-field="obsv-weight[]"]', function (e) {
        e.preventDefault();
        var $form = $(this).closest('form');
        var $section = $(e.target).closest('.record');
        var $weight = $section.find('input[name="obsv-weight[]"]');
        var $height = $section.find('input[name="obsv-height[]"]');
        var $head = $section.find('input[name="obsv-head-ccf[]"]');
        
        fv = $form.data('formValidation');
        if (fv) {
           if($weight.val() !== '' && $height.val() === '' && $head.val() === ''){
            fv.revalidateField($height);
            fv.revalidateField($head);
           }
           if($weight.val() === '' && $height.val() !== '' && $head.val() === ''){
            fv.revalidateField($weight);
            fv.revalidateField($head);
           }
           if($weight.val() === '' && $height.val() === '' && $head.val() !== ''){
            fv.revalidateField($weight);
            fv.revalidateField($height);
           }
        }
    });

    $('#observation-table').on('click', '[data-action="edit"]', function (e) {
        e.preventDefault();
        hideElementClass($('.section--growth-chart'));
        observationTableDoAction(e, 'editing');
        $('.toolbar-nav').addClass('hidden');
    }).on('click', '[data-action="undo-edit"]', function (e) {
        e.preventDefault();
        showElementClass($('.section--growth-chart'));
        observationTableUndoAction(e, 'editing');
    }).on('click', '[data-action="remove"]', function (e) {
        e.preventDefault();
        hideElementClass($('.section--growth-chart'));
        observationTableDoAction(e, 'removing');
        $('.toolbar-nav').addClass('hidden');
    }).on('click', '[data-action="undo-remove"]', function (e) {
        e.preventDefault();
        showElementClass($('.section--growth-chart'));
        observationTableUndoAction(e, 'removing');
    });
    
    var yesBtn = false;
    
    //manage returning focus
    $(document).on('click', '[data-action]', function() {

      var mode = $(this).attr('data-action');
      
      if(mode === 'undo-remove' || mode === 'undo-edit') {
        var dataId = $(this).attr('data-id');
        var target = $('[data-id="' + dataId + '"][data-action="' + mode.replace('undo-', '') + '"]').get(0);

        target.focus();
      }
      
      if(mode === 'edit' || mode === 'remove') {
        var dataId = $(this).attr('data-id');
        var table = $(this).parents('table').first();
      }
      
      var cancelReturn = false;
      
      //disable default return focus
      $('#observation-form-submit-modal')
      .on('show.bs.modal', function() {
        $('#observation-form .btn--primary').removeAttr('disabled').removeClass('disabled');
      })
      .on('shown.bs.modal', function() {
        $(this).attr('disable-return-focus', true);
        cancelReturn = false;
        $(this).find('.btn--primary').on('click', function() {
          cancelReturn = true;
        });
      }).on('hidden.bs.modal', function(e) {
        e.preventDefault();
        
        if(cancelReturn) {
          cancelReturn = false;
          
          switch(mode) {
            case 'edit' :
              var target = $('[data-id="' + dataId + '"]').not('*[data-action="remove"]').get(0);
              break;
              
            case 'remove':
              var target = $('[data-id="' + dataId + '"]').not('*[data-action="edit"]').get(0);
              break;
              
            case 'add-observation':
              var target = $('*[data-action="add-observation"]').get(0);
              break;
          }          
        } else {
          var btnOrigin = (yesBtn) ?  '.btn--primary' : '.btn--secondary';
          target = $('#observation-form').find(btnOrigin).get(0);
        }
        
        if(target) focusEl(target);
      });
      
      function focusEl(el) {
        window.setTimeout(function() { //necessary if button is modified or recreated
          $(el).focus();
        }, 0);
      }
      
    });
    
    $('#observation-form').on('click', '.btn--primary', function() {
      yesBtn = true;
    });
    
    $('#observation-form').on('click', '.btn--secondary', function() {
      yesBtn = false;
    });
    
    var validationDuplicateAndBeforeDate = function validationDuplicateAndBeforeDate($tbDatas, $dateFull, $years, $months, $days, dob, fullname, $tbDates) {
        $tbDatas.forEach(function (val, index) {
            $tbDates.push(val.date);
        });

        $years.forEach(function (val, index) {
            if ($months[index].value > 0 && $months[index].value < 13 && $days[index].value > 0 && $days[index].value < 32 && val.value.length === 4 && ($days[index].value.length === 2 || $days[index].value.length === 1) && ($months[index].value.length === 2 || $months[index].value.length === 1) && moment('01/01/' + val.value, 'DD/MM/YYYY').diff(moment('01/01/1900', 'DD/MM/YYYY')) >= 0) {
                if (moment($months[index].value + '-' + $days[index].value + '-' + val.value, 'MM-DD-YYYY').format('DD-MMM-YYYY') !== 'Invalid date') {
                    var $date = moment($months[index].value + '-' + $days[index].value + '-' + val.value, 'MM-DD-YYYY').format('DD-MMM-YYYY');
                    if ($tbDates.indexOf($date) !== -1) {
                        if (store.getState().observationMode.mode !== 'edit') {
                            $($dateFull[index]).attr('data-duplicate-date', 'yes|' + $date);
                        }
                    } else {
                        $tbDates.push($date);
                        $($dateFull[index]).attr('data-duplicate-date', 'no');
                    }
                    if (moment(dob, 'DD-MMM-YYYY').isAfter(moment($date, 'DD-MMM-YYYY'))) {
                        $($dateFull[index]).attr('data-before-date', 'yes|' + dob + '|' + fullname);
                    } else {
                        $($dateFull[index]).attr('data-before-date', 'no');
                    }

                    if (moment($date, 'DD-MMM-YYYY').isAfter(moment(new Date(), 'DD-MMM-YYYY'))) {
                        $($dateFull[index]).attr('data-after-date', 'yes');
                    } else {
                        $($dateFull[index]).attr('data-after-date', 'no');
                    }

                    $($dateFull[index]).attr('data-invalid-date', 'no');
                } else {
                    $($dateFull[index]).attr('data-invalid-date', 'yes');
                }
            } else {
                $($dateFull[index]).attr('data-duplicate-date', 'no');
                $($dateFull[index]).attr('data-before-date', 'no');
                $($dateFull[index]).attr('data-after-date', 'no');
                $($dateFull[index]).attr('data-invalid-date', 'no');
            }
        });
    };

    var hideElementClass = function hideElementClass(theElementClass) {
        theElementClass.addClass('hidden');
    };

    var updateMinValidationMessage = function updateMinValidationMessage($form, $elementArray, elementName, validator, message) {
        $elementArray.forEach(function (val, index) {
            if (val.validity.rangeUnderflow) {
                $form.data('formValidation').updateMessage(elementName, validator, message);
            }
        });
    };

    var showElementClass = function showElementClass(theElementClass) {
        theElementClass.removeClass('hidden');
    };

    var showWrapLoader = function showWrapLoader(theElementClass) {
        theElementClass.addClass('loader-active');
    };

    var hideWrapLoader = function hideWrapLoader(theElementClass) {
        theElementClass.removeClass('loader-active');
    };

    $('#observation-form-submit-modal').on('click', '[type="submit"]',function (e) {
        e.preventDefault();

        var state = store.getState();
        showElementClass($('.section--growth-chart'));

        if (state.observationMode.mode === 'save') {
            window.location.href = window.location.pathname;
        }

        if (state.observationMode.mode === 'remove' && e.currentTarget.dataset.cancel != 'cancel') {
            submitDataToCDA('observation').done(function (response) {
                window.location.href = window.location.pathname;
            }).fail(function (error) {
                store.dispatch({ type: 'FETCH_REMOTE_DATA_FAIL', error: error });
                console.log(error);
            });
        }

        store.dispatch({ type: 'OBSERVATION_FORM_INIT' });
        store.dispatch({ type: 'OBSERVATION_ENTER_INIT_MODE' });
        store.dispatch({ type: 'OBSERVATION_TABLE_INIT', items: store.getState().server.payload.tbData });

        $('#observation-form-submit-modal').modal('hide');
    }).on('click', '[type="reset"]', function (e) {
        e.preventDefault();
        var state = store.getState();

        $('#observation-form-submit-modal').modal('hide');
        $('#observation-focus-content').focus();
    });

    $('.tbfm__form__tb-filter').on('change', function (e) {
        e.preventDefault();
        var $radioButtons = $('input[name="radio-buttons"]:checked');
        if ($('.tbfm__form__tb-filter').is(":checked") || $('#rimDescription').attr('data-type') === 'NR') { 
            $('.btn.btn--primary.btn-lg').addClass('hidden');
            if ($('.tbfm__form__chart-filter').find(':selected').data('tbcols-show') !== undefined) {
                hideColumns($('.tbfm__form__chart-filter').find(':selected').data('tbcols-show').split(',').map(function (val) {
                    return parseInt(val, 10);
                }), [2, 3, 4, 5, 6, 7, 8]);
                if ($('.tbfm__form__chart-filter').find(':selected').val() !== undefined) {
                    hideRows($('.tbfm__form__chart-filter').find(':selected').val().split('|'));
                } else {
                    hideRows([-1]);
                }
            }
        } else {
            if($radioButtons && $($radioButtons.closest("tr")).index() > 0){
                $('.btn.btn--primary.btn-lg').addClass('hidden');
                hideColumns($('.tbfm__form__chart-filter').find(':selected').data('tbcols-show').split(',').map(function (val) {
                    return parseInt(val, 10);
                }), [2, 3, 4, 5, 6, 7, 8]);
                if ($('.tbfm__form__chart-filter').find(':selected').val() !== undefined) {
                    hideRows($('.tbfm__form__chart-filter').find(':selected').val().split('|'));
                } else {
                    hideRows([-1]);
                }
            } else {                
                $('.btn.btn--primary.btn-lg').removeClass('hidden');
                hideColumns([4, 5, 6, 8], [2, 3, 7]);
                if ($('.tbfm__form__chart-filter').find(':selected').val() !== undefined) {
                    hideRows($('.tbfm__form__chart-filter').find(':selected').val().split('|'));
                } else {
                    hideRows([-1]);
                }
            }
        }
        
        if($('*[aria-label=" Consumer Entered Observation "]').length !== 0) {
          
          var plotPoints = $('*[aria-label=" Consumer Entered Observation "]');
          
          //add role presentation to parent svg
          plotPoints.first().parents('svg').first().attr('role', 'presentation');
          
          //hide other shapes in SR
          var parentShapes = plotPoints.first().parents('g');
          $('.amcharts-chart-div g').not(parentShapes).attr('aria-hidden', 'true');
          
          plotPoints.each(function(i, el) {
            
            $(el).attr({
              'tabindex' : 0,
              'role' : 'button',
              'aria-describedby' : 'observation-info-' + i
            })
            
            $(el).on('click focus', function(e) {
              $(this).trigger('mouseover');
              if(event.type === 'click') $(this).focus();
            }).on('blur', function() {
              $(this).trigger('mouseout');
            });
          });
        }
    });

    $('.tbfm__form__chart-filter').on('change', function (e) {
        e.preventDefault();
        if ($('.tbfm__form__chart-filter').find(':selected').data('tbcols-show') !== undefined) {
            hideColumns($('.tbfm__form__chart-filter').find(':selected').data('tbcols-show').split(',').map(function (val) {
                return parseInt(val, 10);
            }), [2, 3, 4, 5, 6, 7, 8]);
            $('.btn.btn--primary.btn-lg').addClass('hidden');
        } else {
            hideColumns([4, 5, 6, 8], [2, 3, 7]);
            $('.checkbox').addClass('hidden');
            $('.btn.btn--primary.btn-lg').removeClass('hidden');
        }

        if ($('.tbfm__form__chart-filter').find(':selected').val() !== undefined) {
            var $radioButtons = $('input[name="radio-buttons"]:checked');

            hideRows($('.tbfm__form__chart-filter').find(':selected').val().split('|'));
            if($('.tbfm__form__chart-filter').find(':selected').val() === '' && ($radioButtons && $($radioButtons.closest("tr")).index() > 0)){                
                hideColumns([], [8]);
                $('.checkbox').addClass('hidden');
                $('.btn.btn--primary.btn-lg').addClass('hidden');
            }
        } else {
            hideRows([-1]);
        }
    });

    var hideColumns = function hideColumns(show, hide) {

        show.forEach(function (item, index) {
            $('#observation-table thead tr th:nth-child(' + item + ')').removeClass('hidden');
            $('#observation-table tbody tr td:nth-child(' + item + ')').removeClass('hidden');
            $('.checkbox').removeClass('hidden');
        });
        hide.forEach(function (item, index) {
            if (show.indexOf(item) === -1) {
                $('#observation-table thead tr th:nth-child(' + item + ')').addClass('hidden');
                $('#observation-table tbody tr td:nth-child(' + item + ')').addClass('hidden');
            }
        });
    };

    var hideRows = function hideRows(range) {
        var dob = store.getState().server.payload.dob;
        var rows = document.querySelector("#observation-table tbody").rows;
        var isAllRowHidden = true;
        $.each(rows, function (key, row) {
            if ($('.tbfm__form__tb-filter').is(":checked")) {
                var rowVal = row.cells[1].innerText;
                var rowDate = row.cells[0].innerText;
                if (rowVal === 'Birth') {
                    rowVal = '0';
                }
                if (parseInt(rowVal, 10) >= parseInt(range[2], 10) && parseInt(rowVal, 10) <= parseInt(range[3], 10)) {
                  if(parseInt(rowVal, 10) === parseInt(range[3], 10)) {
                    //if age is equal to range. get the date if it is not greater than dob
                    var dobDay = parseInt(dob.split('-')[0], 10);
                    var rowDay = parseInt(rowDate.split('-')[0], 10);
                    
                    if(rowDay <= dobDay) {
                      row.hidden = false;
                      isAllRowHidden = false;
                    } else {
                      row.hidden = true;
                    }
                    
                  } else {
                    row.hidden = false;
                    isAllRowHidden = false;
                  }
                } else {
                    if (range[0] === "") {
                        row.hidden = false;
                        isAllRowHidden = false;
                    } else row.hidden = true;
                }
            } else {
                row.hidden = false;
                isAllRowHidden = false;
            }
        });
        if (isAllRowHidden && $('.tbfm__form__tb-filter').is(":checked")) {
            $('.table--base').addClass('hidden');
        } else {
            $('.table--base').removeClass('hidden');
            $('#observations-no-data').remove();
        }
    };

    $('.btn__history').on('click', function (e) {
        e.preventDefault();
        var docid = '';
        var repoid = '';
        var historyTbody = '.js-clickTrToCheckRdo';
        var $radioButtons = $('input[name="radio-buttons"]:checked');

        if ($(historyTbody + " tr").length === 1) {
            $(historyTbody + " td:first-child").find(".radio").remove();
        }

        $('.btn__access').removeClass('hidden');
        if ($('.btn__history').attr('data-mode') === 'hide') {
            hideColumns([], [8]);
            $('.checkbox').addClass('hidden');
            $('.btn.btn--primary.btn-lg').addClass('hidden');
            $(historyTbody).parent().removeClass('hidden');
            if($radioButtons && $($radioButtons.closest("tr")).index() > 0){
                $('.btn__access').addClass('hidden');
            }
            else if($radioButtons && $($radioButtons.closest("tr")).index() === 0){
                $('.btn__access').removeClass('hidden');
            }
        } else {
            if ((($radioButtons && $($radioButtons.closest("tr")).index() === 0 && $('.btn__history').attr('data-mode')) || ($(historyTbody + " tr").length === 1) ) && $('.btn__history').attr('data-mode')) {
                if($('.action').length !== 0) $('.action').removeClass('hidden');
                if($('*[data-action="add-observation"').length !== 0) $('*[data-action="add-observation"').removeClass('hidden');
            }
            if($radioButtons && $($radioButtons.closest("tr")).index() > 0){
                $('.btn__access').addClass('hidden');
            }
            if ($('.btn__history').attr('data-mode')) {
                $(historyTbody).parent().addClass('hidden');
            } else{
                $(historyTbody).parent().removeClass('hidden');
                if ($('.btn__history').attr('data-mode') != 'hide') {
                    $('.btn.btn--primary.btn-lg').addClass('hidden');
                    hideColumns([], [8]);
                    $('.checkbox').addClass('hidden');
                }
                hideButtonsAndColumns();
            }
        }
    });

    $('.btn__access').on('click', function (e) {
        $('.btn__access').removeClass('hidden');
        if ($('.btn__access').attr('data-mode') === 'hide' || typeof $('.btn__access').attr('data-mode') === 'undefined') {
            hideColumns([], [8]);
            $('.checkbox').addClass('hidden');
            $('.btn.btn--primary.btn-lg').addClass('hidden');
        } else {
            hideColumns([8], []);
            $('.btn.btn--primary.btn-lg').removeClass('hidden');
            $('.checkbox').addClass('hidden');
        }
    });

    $('.toolbar-history table tbody').on('click', 'tr', function (e) {
        e.preventDefault();
        if ($(this).index() === 0) {
            $('.btn__access').removeClass('hidden');
        } else {
            $('.btn__access').addClass('hidden');
        }
        var $that = $(this);
        var docid = $.trim($that.attr('data-docid'));
        var repoid = $.trim($that.attr('data-repoid'));
        rm.tbfm.setCurrDocId(docid);
        getHistoryData({ url: '/ncp/getHealthObservation', type: 'get', docid: docid, repoid: repoid, mode: 'history' }).done(function (data) {
            updateTableData(data);
            hideColumns([], [8]);
            $('.btn.btn--primary.btn-lg').addClass('hidden');
            $('.checkbox').addClass('hidden');
        }).fail(function (error) {
            store.dispatch({ type: 'FETCH_REMOTE_DATA_FAIL', error: error });
            console.log(error);
        });
    });

    var hideButtonsAndColumns = function hideButtonsAndColumns() {
        if ($('#rimDescription').attr('data-type') === 'NR') {
            $('.btn.btn--primary.btn-lg').addClass('hidden');
            hideColumns([], [8]);
        }
    };

    var updateTableData = function updateTableData(data) {
        store.dispatch({ type: 'FETCH_REMOTE_DATA' });
        store.dispatch({
            type: 'OBSERVATION_TABLE_INIT',
            items: data.tbData.map(function (item) {
                item.status = 'saved';
                return item;
            })
        });
        store.dispatch({ type: 'FETCH_REMOTE_DATA_SUCCESS', payload: data });
    };

    var getHistoryData = function getHistoryData(_ref4) {
        var url = _ref4.url,
            _ref4$type = _ref4.type,
            type = _ref4$type === undefined ? 'get' : _ref4$type,
            docid = _ref4.docid,
            repoid = _ref4.repoid,
            mode = _ref4.mode;

        var defer = $.Deferred();
        var ajaxConfig = void 0;
        if (mode === 'history') ajaxConfig = {
            url: url,
            type: type,
            data: {
                'repositoryUniqueId': repoid,
                'documentUniqueId': docid
            },
            beforeSend: function() {
                if($('*[name="radio-buttons"]').length !== 0) $('*[name="radio-buttons"]').attr('disabled','disabled');
            },
            success: function success(response) {
                if($('*[name="radio-buttons"]').length !== 0) {
                    $('*[name="radio-buttons"]').removeAttr('disabled');
                    $('*[name="radio-buttons"]:checked').focus();
                }
                if (response == null) {
                    return defer.reject('DOCLIST_NULL');
                }
                return defer.resolve(JSON.parse(response));
            },
            error: defer.reject
        };else {
            ajaxConfig = {
                url: url,
                type: type,
                success: function success(response) {
                    if (response == null) {
                        return defer.reject('DOCLIST_NULL');
                    }
                    return defer.resolve(JSON.parse(response));
                },
                error: defer.reject
            };
        }

        $.ajax(ajaxConfig);

        return defer.promise();
    };
})(jQuery, Redux, rm.calc, rm.toolbar);

/* jshint ignore:end */
(function(){

  'use strict';


  // var htmlReg = /<([a-zA-Z]*)\b[^>]*>(.*?)</\1>/g;
  var htmlReg = new RegExp('<([a-zA-Z]*)\\b[^>]*>(.*?)</\\1>','g');

  var selectTpl = function selectTpl(title) {
    var id = title.replace(/\s*/g, "");
    var label = title.replace(/Hidden/g, "");
    return (
      '\n\t<div class="row">\n\t\t<div class="col-sm-4">\n          <div class="form-group ">\n              <label for="' +
      id +
      '" class="btn--block" data-title="' +
      title +
      '">\n                ' +
      label +
      '\n                <span class="validation-wrapper validation-wrapper--dropdown">\n                  <select class=" native-select form-control" id="' +
      id +
      '" name="' +
      id +
      '">\n                      <option value="">All</option>\n                  </select>\n                  <span class="print__icon">\n                      <img class="drop-arrow"  alt="Dropdown arrow" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNSAyNSI+PHRpdGxlPkRvd24gYXJyb3c8L3RpdGxlPjxzdHlsZT4uc3Qwe2ZpbGw6IzFGNkRCMX08L3N0eWxlPjxwYXRoIGQ9Ik0xMi42IDE3LjFsLTYuNy02LjdjLS41LS41LS41LTEuMiAwLTEuNi41LS41IDEuMi0uNSAxLjYgMGw1LjEgNS4xIDUuMS01LjFjLjUtLjUgMS4yLS41IDEuNiAwIC41LjUuNSAxLjIgMCAxLjZsLTYuNyA2Ljd6IiBjbGFzcz0ic3QwIi8+PC9zdmc+DQo=">\n                    </span>\n                </span>\n            </label>\n          </div>\n\t\t</div>\n\t</div>\n      '
    );
  };

  "use strict";

  var alertTempt = function alertTempt(text) {
    return (
      '\n<div class="alert alert--notification alert--white alert--border--sky-blue alert--no-data" tabindex="-1" role="alert" aria-describedby="alert-description-13" tabindex="0">\n              \n                <div class="alert__icon alert__icon--valign-top alert__icon--fixed-width">\n                  <span class="icon icon--lg icon--info-circle">\n                    <span class="sr-only">Alert Information</span>\n                    <span class="print__icon">\n                        <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                    </span>\n                  </span>\n                </div>\n                <div class="alert__message ">\n                   \n                  <div class="alert__message__content" id="alert-description-13">' +
      text +
      "</div>\n                  \n                </div>\n              \n            </div>\n"
    );
  };




  var imagingTable;

  rm.domReady.done(function () {
    if(!(rm.globals.DOM.body.hasClass('diagnostic-imaging'))) return;

    if ( $.fn.dataTable.isDataTable( '#diagnostic-ng' ) ) {
      setupFilters();
    } else {
      rm.table.init();
      setupFilters();
    }

    $('#filter-imaging-form')
    .on('submit',function(e){
      e.preventDefault();
      searchTable.bind(this)(false);

    })
    .on('reset',function(){
      searchTable.bind(this)(true);
    });

    function setupFilters() {
      imagingTable = $('#diagnostic-ng').DataTable();

      imagingTable.columns().every( function () {
        var column = this;
        var hasHtml = false;
        var selectedFilters = ['Examination Hidden', 'Imaging Organisation', 'Requester'];
        var header = column.header().textContent;

        column.data().unique().each(function(el){
             if( el.match(htmlReg) !== null ) {
                hasHtml = true;
             }
        });

        if( !hasHtml ) {
          if(selectedFilters.indexOf($.trim(header)) !== -1) {
            var select = $(selectTpl(header))
                .appendTo( $('.table-filter-wrapper') )
                .find('select');

            var options = [];
            column.data()
            .each( function ( d, j ) {
                options.push(d);
            } );

            options
            .map(function( option ){
              return option.replace(/\s+/g,' ');
            })
            .uniqueOnFirstOccurence()
            .sort()
            .forEach(function( d ){
                select.append( '<option value="'+d+'">'+d+'</option>' );
            });
          }
        }
      } );
    }


    function searchTable(reset) {
      reset = reset || false;
      var $form = $(this);
      var $formControls = $form.find('.table-filter-wrapper > .row').not('.hidden').find('label');
      var searchValues = $.map($formControls, function(el){
        return {
                "title":$(el).data('title'),
                "value":$.fn.dataTable.util.escapeRegex($(el).find('.form-control').val())
              }
      });
      var searchMap = {};

      $.each(searchValues, function( index, value ) {
        searchMap[value.title] = value.value;
      });
      imagingTable.columns().every( function () {
        var column = this;
        var header = column.header().textContent;

        if(typeof searchMap[header] !== 'undefined'){
          if( reset ) {

            column
            .search( '', true, false);

          } else {

            column
            .search(searchMap[header] ? '^'+searchMap[header]+'$' : '', true, false);
          }
        }
        column.draw();
      });

      $('p.dataTables_empty').remove();
      $('.alert--no-data').remove();
      if(imagingTable.page.info().recordsDisplay > 0) {

        $('.dataTables_info p').removeClass('hidden');
        $('#diagnostic-ng').removeClass('hidden').focus();
      } else {

        $('#diagnostic-ng').after(alertTempt($('.dataTables_empty').text()))
        .next()
        .focus();
        $('#diagnostic-ng').addClass('hidden');
        $('.dataTables_info p').addClass('hidden');
      }

      rm.pageLength.init();
    }
  });
})();
(function(){

  'use strict';

  rm.domReady.done(function () {
        if ($('body.page--growth-chart').length === 0) return;

    rm.tbfm.init('/js/data/getHealthObservation.json', '/js/data/getGrowthChartData.json');

    rm.tbfm.loadChartData('/js/data/getGrowthChartData.json','/js/data/getHealthObservation.json');

  });

})();
(function(){

  'use strict';

  rm.domReady.done(function () {
      $('.toolbar-history table').on('click', 'tr', function(){
          $(this).addClass('selected')
          .siblings()
          .removeClass('selected');
      });
  });

})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('view-ulc')) return;

    rm.domReady.done(function() {
    
    // Show popup if no error in email field
    $('#formAdminUnverifiedIdentityEmailULC').on('success.form.fv', function(e) {
        $('#modalULCCodeSuccess').modal('show');
        e.preventDefault();
    });        

    // Show popup if no error in sms field
    $('#formAdminUnverifiedIdentityMobileULC').on('success.form.fv', function(e) {
        $('#modalULCCodeSuccess').modal('show');
        e.preventDefault();
    });     

    });
})();
(function() {

    'use strict';

    rm.domReady.done(function() {
        
        // Consume ULC popup submit successful
        $('#consumeULCForm').on('success.form.fv', function(e) {
            e.preventDefault();
            $('#modalConsumeULC').modal('hide');
            $('#modalConsumeULCSuccess').appendTo('body').modal('show');
        });  

    });
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('admin-intention-cancel-record')) return;

    rm.domReady.done(function() {
    
    var form   = "#formAdminIntentionCancelRecord",
        $form  = $(form);

    // Show popup if no error in email field
    $form.on('success.form.fv', function(e) {
        e.preventDefault();
        $('#modalIntentionCancelRecordSuccess').modal('show');
    });        


    });
})();
(function() {

    'use strict';

    if (!rm.globals.DOM.body.hasClass('admin-cancel-record')) return;

    rm.domReady.done(function() {
    
    var form   = "#formAdminCancelRecord",
        $form  = $(form);

    // Show popup if no error in email field
    $form.on('success.form.fv', function(e) {
        e.preventDefault();
        $('#modalCancelRecordSuccess').modal('show');
    });        


    });
})();
(function(){

  'use strict';


  // var htmlReg = /<([a-zA-Z]*)\b[^>]*>(.*?)</\1>/g;
  var htmlReg = new RegExp('<([a-zA-Z]*)\\b[^>]*>(.*?)</\\1>','g');

  var selectTpl = function selectTpl(title) {
    var id = title.replace(/\s*/g, "");
    var label = title.replace(/Hidden/g, "");
    return (
      '\n\t<div class="row">\n\t\t<div class="col-sm-4">\n          <div class="form-group ">\n              <label for="' +
      id +
      '" class="btn--block" data-title="' +
      title +
      '">\n                ' +
      label +
      '\n                <span class="validation-wrapper validation-wrapper--dropdown">\n                  <select class=" native-select form-control" id="' +
      id +
      '" name="' +
      id +
      '">\n                      <option value="">All</option>\n                  </select>\n                  <span class="print__icon">\n                      <img class="drop-arrow"  alt="Dropdown arrow" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNSAyNSI+PHRpdGxlPkRvd24gYXJyb3c8L3RpdGxlPjxzdHlsZT4uc3Qwe2ZpbGw6IzFGNkRCMX08L3N0eWxlPjxwYXRoIGQ9Ik0xMi42IDE3LjFsLTYuNy02LjdjLS41LS41LS41LTEuMiAwLTEuNi41LS41IDEuMi0uNSAxLjYgMGw1LjEgNS4xIDUuMS01LjFjLjUtLjUgMS4yLS41IDEuNiAwIC41LjUuNSAxLjIgMCAxLjZsLTYuNyA2Ljd6IiBjbGFzcz0ic3QwIi8+PC9zdmc+DQo=">\n                    </span>\n                </span>\n            </label>\n          </div>\n\t\t</div>\n\t</div>\n      '
    );
  };

  var alertTempt = function alertTempt(text) {
    return (
      '\n<div class="alert alert--notification alert--white alert--border--sky-blue alert--no-data" tabindex="-1" role="alert" aria-describedby="alert-description-13" tabindex="0">\n              \n                <div class="alert__icon alert__icon--valign-top alert__icon--fixed-width">\n                  <span class="icon icon--lg icon--info-circle">\n                    <span class="sr-only">Alert Information</span>\n                    <span class="print__icon">\n                        <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                    </span>\n                  </span>\n                </div>\n                <div class="alert__message ">\n                   \n                  <div class="alert__message__content" id="alert-description-13">' +
      text +
      "</div>\n                  \n                </div>\n              \n            </div>\n"
    );
  };


  var imagingTable;

  rm.domReady.done(function () {
    if(!(rm.globals.DOM.body.hasClass('pathology'))) return;

    if ( $.fn.dataTable.isDataTable( '#pathology-ng' ) ) {
      setupFilters();
    } else {
      rm.table.init();
      setupFilters();
    }

    $('#filter-pathology-form')
    .on('submit',function(e){
      e.preventDefault();
      searchTable.bind(this)(false);

    })
    .on('reset',function(){
      searchTable.bind(this)(true);
    });

    function setupFilters() {
      imagingTable = $('#pathology-ng').DataTable();

      imagingTable.columns().every( function () {
        var column = this;
        var hasHtml = false;
        var selectedFilters = ['Pathology Test Name Hidden', 'Pathology Organisation', 
        'Requester'];
        var header = column.header().textContent;

        column.data().unique().each(function(el){
             if( el.match(htmlReg) !== null ) {
                hasHtml = true;
             }
        });
        
        if( !hasHtml ) {
          if(selectedFilters.indexOf($.trim(header)) !== -1) {
            var select = $(selectTpl(header))
                .appendTo( $('.table-filter-wrapper') )
                .find('select');

            var options = [];
            column.data()
            .each( function ( d, j ) {
                options.push(d);
            } );

            options
            .uniqueOnFirstOccurence()
            .sort()
            .forEach(function( d ){
                select.append( '<option value="'+d+'">'+d+'</option>' );
            });
          }
        }
      } );
    }

    function searchTable(reset) {
      reset = reset || false;
      var $form = $(this);
      var $formControls = $form.find('.table-filter-wrapper > .row').not('.hidden').find('label');
      var searchValues = $.map($formControls, function(el){
        return {
                "title":$(el).data('title'),
                "value":$.fn.dataTable.util.escapeRegex($(el).find('.form-control').val())
              }
      });
      var searchMap = {};
      $.each(searchValues, function( index, value ) {
        searchMap[value.title] = value.value;
      });
      imagingTable.columns().every( function () {
        var column = this;
        var header = column.header().textContent;

        if(typeof searchMap[header] !== 'undefined'){
          if( reset ) {

            column
            .search( '', true, false);

          } else {

            column
            .search(searchMap[header] ? '^'+searchMap[header]+'$' : '', true, false);
          }
        }
        column.draw();
      });

      $('p.dataTables_empty').remove();
      $('.alert--no-data').remove();
      if(imagingTable.page.info().recordsDisplay > 0) {
        $('.dataTables_info p').removeClass('hidden');
        $('#pathology-ng').removeClass('hidden').focus();
      } else {
        $('#pathology-ng').after(alertTempt($('.dataTables_empty').text()))
          .next()
          .focus();
        $('#pathology-ng').addClass('hidden');
        $('.dataTables_info p').addClass('hidden');
      }

      rm.pageLength.init();
    }
  });

  // fix for safari browser
  setTimeout(function() {
      var $hiddenOpt = $('.dataTables_length .native-select .hidden');
      $hiddenOpt.remove();
  }, 500);
})();
(function() {

    'use strict';

    if (rm.globals.DOM.body.hasClass('manage-nom-rep') || 
      rm.globals.DOM.body.hasClass('manage-pending-nom-rep')) {

      rm.domReady.done(function() {
      
        $('#formManageNomRep').on('success.form.fv', function(e) {
            $('#modalRemoveAccess').modal('show');
            e.preventDefault();
        });          

      });
    }
})();
(function(){

  'use strict';

  var htmlReg = new RegExp('<([a-zA-Z]*)\\b[^>]*>(.*?)</\\1>','g'); 
  var allCapReg = new RegExp('\\b[A-Z\\(\\)]+\\b');

  var selectTpl = function selectTpl(title) {
    var id = title.replace(/\s*/g, "");
    var label = title.replace(/Hidden/g, "");
    return (
      '\n\t<div class="row">\n\t\t<div class="col-sm-4">\n          <div class="form-group ">\n              <label for="' +
      id +
      '" class="btn--block" data-title="' +
      title +
      '">\n                ' +
      label +
      '\n                <span class="validation-wrapper validation-wrapper--dropdown">\n                  <select class=" native-select form-control" id="' +
      id +
      '" name="' +
      id +
      '">\n                      <option value="">All</option>\n                  </select>\n                  <span class="print__icon">\n                      <img class="drop-arrow"  alt="Dropdown arrow" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNSAyNSI+PHRpdGxlPkRvd24gYXJyb3c8L3RpdGxlPjxzdHlsZT4uc3Qwe2ZpbGw6IzFGNkRCMX08L3N0eWxlPjxwYXRoIGQ9Ik0xMi42IDE3LjFsLTYuNy02LjdjLS41LS41LS41LTEuMiAwLTEuNi41LS41IDEuMi0uNSAxLjYgMGw1LjEgNS4xIDUuMS01LjFjLjUtLjUgMS4yLS41IDEuNiAwIC41LjUuNSAxLjIgMCAxLjZsLTYuNyA2Ljd6IiBjbGFzcz0ic3QwIi8+PC9zdmc+DQo=">\n                    </span>\n                </span>\n            </label>\n          </div>\n\t\t</div>\n\t</div>\n      '
    );
  };

  var alertTempt = function alertTempt(text) {
    return (
      '\n<div class="alert alert--notification alert--white alert--border--sky-blue alert--no-data" tabindex="-1" role="alert" aria-describedby="alert-description-13" tabindex="0">\n              \n                <div class="alert__icon alert__icon--valign-top alert__icon--fixed-width">\n                  <span class="icon icon--lg icon--info-circle">\n                    <span class="sr-only">Alert Information</span>\n                    <span class="print__icon">\n                        <svg width="23px" height="23px" viewBox="0 0 23 23" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Alert Information</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-50.000000, -375.000000)"><g transform="translate(50.000000, 375.000000)"><path d="M11.5,1 C5.70428475,1 1,5.70428475 1,11.5 C1,17.2957153 5.70428475,22 11.5,22 C17.2957153,22 22,17.2957153 22,11.5 C22,5.70428475 17.2957153,1 11.5,1 Z" stroke="#1F6DB1" stroke-width="2"></path><path d="M10.35,8.05 L12.65,8.05 L12.65,5.75 L10.35,5.75 L10.35,8.05 Z M10.35,17.25 L12.65,17.25 L12.65,10.35 L10.35,10.35 L10.35,17.25 Z" fill="#1F6DB1" fill-rule="evenodd" transform="translate(11.500000, 11.500000) rotate(180.000000) translate(-11.500000, -11.500000) "></path></g></g></g></svg>\n                    </span>\n                  </span>\n                </div>\n                <div class="alert__message ">\n                   \n                  <div class="alert__message__content" id="alert-description-13">' +
      text +
      "</div>\n                  \n                </div>\n              \n            </div>\n"
    );
  };

  var imagingTable;

  rm.domReady.done(function () {
    if(!(rm.globals.DOM.body.hasClass('prescriptions'))) return;

    if ( $.fn.dataTable.isDataTable( '#prescription-ng' ) ) {
      setupFilters();
    } else {
      rm.table.init();
      setupFilters();
    }

    $('#filter-prescription-form')
    .on('submit',function(e){
      e.preventDefault();
      searchTable.bind(this)(false);

    })
    .on('reset',function(){
      searchTable.bind(this)(true);
    });

    function setupFilters() {
      imagingTable = $('#prescription-ng').DataTable();

      imagingTable.columns().every( function () {
        var column = this;
        var hasHtml = false;
        var selectedFilters = ['record type', 'medicine - active ingredient(s)', 
        'medicine - brand name'];
        var header = column.header().textContent;
        var filteredHeader = $.trim(header).toLowerCase();
        var filterUniqueValue = [];
        var cleanBrandNameData = []; 
        column.data().unique().each(function(el){
             if( el.match(htmlReg) !== null ) {
                hasHtml = true;
             } 
        });

        if( !hasHtml ) {
          if(selectedFilters.indexOf($.trim(filteredHeader)) !== -1) {
            var select = $(selectTpl(header))
                .appendTo( $('.table-filter-wrapper') )
                .find('select');

            if(filteredHeader !== 'medicine - brand name') {
              var options = [];
              column.data()
              .each( function ( d, j ) {
                  options.push(d.replace(/\s+/g,' '));
              } );

              options
                .uniqueOnFirstOccurence()
                .map(function( option ){
                  return option.replace(/\s+/g,' ');
                })
                .sort()
                .forEach(function( d ){
                  if(filteredHeader === 'medicine - active ingredient(s)') {
                    d = d.toLowerCase();
                  }
                  if(d !== '')
                    select.append( '<option value="'+d+'">'+d+'</option>' );
                });
            }

          
            
            if(filteredHeader === 'medicine - brand name') {
              var options = [];
              column.data()
              .each( function ( d, j ) {
                  var arrBrandName = d.split('-');
                  options.push($.trim(arrBrandName[0]));
              } );

              options
                .uniqueOnFirstOccurence()
                .map(function( option ){
                  return option.replace(/\s+/g,' ');
                })
                .sort()
                .forEach(function( d ){
                  if( allCapReg.test(d) ) {
                      d = covertAllCapToLower(d);
                  }
                  if(d !== '') {
                    d = capitalFirstLetter(d);
                    select.append( '<option value="'+d+'">'+d+'</option>' );
                  }
                });
            }
          }
        }
      } );
    }

    function covertAllCapToLower(str) {
      var newString = str.toLowerCase().replace(/\b[A-Z]+\b/g,function(c){
        return c.toLowerCase()
      });
      return newString;
    }

    function capitalFirstLetter(word) {
      var newString = word.replace(/(^\w)/g,function(c) {
        return c.toUpperCase();
      });
      return newString;
    }

    function searchTable(reset) {
      reset = reset || false;
      var $form = $(this);
      var $formControls = $form.find('.table-filter-wrapper > .row').not('.hidden').find('label');
      var searchValues = $.map($formControls, function(el){
        return {
                "title":$(el).data('title'),
                "value":$.fn.dataTable.util.escapeRegex($(el).find('.form-control').val())
              }
      });
      var searchMap = {};
      $.each(searchValues, function( index, value ) {
        searchMap[value.title] = value.value;
      });
      imagingTable.columns().every( function () {
        var column = this;
        var header = column.header().textContent;

        if(typeof searchMap[header] !== 'undefined'){
          if( reset ) {

            column
            .search( '', true, false);

          } else {

            column
            .search(searchMap[header] ? searchMap[header] : '', true, false);
          }
        }
        column.draw();
      });
      $('p.dataTables_empty').remove();
      $('.alert--no-data').remove();
      
      if(imagingTable.page.info().recordsDisplay > 0) {
        $('.dataTables_info p').removeClass('hidden');
        $('#prescription-ng').removeClass('hidden').focus();
      } else {
        $('#prescription-ng').after(alertTempt($('.dataTables_empty').text()))
          .next()
          .focus();
        $('#prescription-ng').addClass('hidden');
        $('.dataTables_info p').addClass('hidden');
      }

      rm.pageLength.init();
    }
  });
})();
(function () {

  'use strict';

  // onboarding modal - moved outside domReady to avoid conflict for MS Edge browser
  $(window).load(function() {
    $('#modalOnboarding').modal();
  });

  rm.domReady.done(function() {

    // Carousel Extension
      // ===============================
    
          $('.carousel').each(function (index) {
    
            // This function positions a highlight box around the tabs in the tablist to use in focus styling
    
            function setTablistHighlightBox() {
    
              var $tab
                  , offset
                  , height
                  , width
                  , highlightBox = {}
    
                highlightBox.top     = 0
              highlightBox.left    = 32000
              highlightBox.height  = 0
              highlightBox.width   = 0
    
              for (var i = 0; i < $tabs.length; i++) {
                $tab = $tabs[i]
                offset = $($tab).offset()
                height = $($tab).height()
                width  = $($tab).width()
    
    //            console.log(" Top: " + offset.top + " Left: " + offset.left + " Height: " + height + " Width: " + width)
    
                if (highlightBox.top < offset.top) {
                  highlightBox.top    = Math.round(offset.top)
                }
    
                if (highlightBox.height < height) {
                  highlightBox.height = Math.round(height)
                }
    
                if (highlightBox.left > offset.left) {
                  highlightBox.left = Math.round(offset.left)
                }
    
                var w = (offset.left - highlightBox.left) + Math.round(width)
    
                if (highlightBox.width < w) {
                  highlightBox.width = w
                }
    
              } // end for
    
    //          console.log("[HIGHLIGHT]  Top: " +  highlightBox.top + " Left: " +  highlightBox.left + " Height: " +  highlightBox.height + " Width: " +  highlightBox.width)
    
              $tablistHighlight.style.top    = (highlightBox.top    - 2)  + 'px'
              $tablistHighlight.style.left   = (highlightBox.left   - 2)  + 'px'
              $tablistHighlight.style.height = (highlightBox.height + 7)  + 'px'
              $tablistHighlight.style.width  = (highlightBox.width  + 8)  + 'px'
    
            } // end function
    
            var $this = $(this)
              , $prev        = $this.find('[data-slide="prev"]')
              , $next        = $this.find('[data-slide="next"]')
              , $tablist    = $this.find('.carousel-indicators')
              , $tabs       = $this.find('.carousel-indicators li')
              , $tabpanels  = $this.find('.item')
              , $tabpanel
              , $tablistHighlight
              , $pauseCarousel
              , $complementaryLandmark
              , $tab
              , $is_paused = false
              , offset
              , height
              , width
              , i
              , id_title  = 'id_title'
              , id_desc   = 'id_desc'
    
    
            $tablist.attr('role', 'tablist')
    
            $tabs.focus(function() {
              $this.carousel('pause')
              $is_paused = true
              $pauseCarousel.innerHTML = "Play Carousel"
              $(this).parent().addClass('active');
    //          $(this).addClass('focus')
              setTablistHighlightBox()
              $($tablistHighlight).addClass('focus')
              $(this).parents('.carousel').addClass('contrast')
            })
    
            $tabs.blur(function(event) {
              $(this).parent().removeClass('active');
    //          $(this).removeClass('focus')
              $($tablistHighlight).removeClass('focus')
              $(this).parents('.carousel').removeClass('contrast')
            })
    
    
            for (i = 0; i < $tabpanels.length; i++) {
              $tabpanel = $tabpanels[i]
              $tabpanel.setAttribute('role', 'tabpanel')
              $tabpanel.setAttribute('id', 'tabpanel-' + index + '-' + i)
              $tabpanel.setAttribute('aria-labelledby', 'tab-' + index + '-' + i)
            }
    
            if (typeof $this.attr('role') !== 'string') {
              $this.attr('role', 'complementary');
              $this.attr('aria-labelledby', id_title);
              $this.attr('aria-describedby', id_desc);
              $this.prepend('<p  id="' + id_desc   + '" class="sr-only">A carousel is a rotating set of images, rotation stops on keyboard focus on carousel tab controls or hovering the mouse pointer over images.  Use the tabs or the previous and next buttons to change the displayed slide.</p>')
              $this.prepend('<h2 id="' + id_title  + '" class="sr-only">Carousel content with ' + $tabpanels.length + ' slides.</h2>')
            }
    
    
            for (i = 0; i < $tabs.length; i++) {
              $tab = $tabs[i]
    
              $tab.setAttribute('role', 'tab')
              $tab.setAttribute('id', 'tab-' + index + '-' + i)
              $tab.setAttribute('aria-controls', 'tabpanel-' + index + '-' + i)
    
              var tpId = '#tabpanel-' + index + '-' + i
              var caption = $this.find(tpId).find('h1').text()
    
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = $this.find(tpId).text()
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = $this.find(tpId).find('h3').text()
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = $this.find(tpId).find('h4').text()
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = $this.find(tpId).find('h5').text()
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = $this.find(tpId).find('h6').text()
              if ((typeof caption !== 'string') || (caption.length === 0)) caption = "no title";
    
    //          console.log("CAPTION: " + caption )
    
              var tabName = document.createElement('span')
              tabName.setAttribute('class', 'sr-only')
              tabName.innerHTML='Slide ' + (i+1)
              if (caption) tabName.innerHTML += ": " +  caption
              $tab.appendChild(tabName)
    
             }
    
            // create div for focus styling of tablist
            $tablistHighlight = document.createElement('div')
            $tablistHighlight.className = 'carousel-tablist-highlight'
            document.body.appendChild($tablistHighlight)
    
            // create button for screen reader users to stop rotation of carousel
    
            // create button for screen reader users to pause carousel for virtual mode review
            $complementaryLandmark = document.createElement('aside')
            $complementaryLandmark.setAttribute('class', 'carousel-aside-pause')
            $complementaryLandmark.setAttribute('aria-label', 'carousel pause/play control')
            $this.prepend($complementaryLandmark)
    
            $pauseCarousel = document.createElement('button')
            $pauseCarousel.className = "carousel-pause-button"
            $pauseCarousel.innerHTML = "Pause Carousel"
            $pauseCarousel.setAttribute('title', "Pause/Play carousel button can be used by screen reader users to stop carousel animations")
            $($complementaryLandmark).append($pauseCarousel)
    
            $($pauseCarousel).click(function() {
              if ($is_paused) {
                $pauseCarousel.innerHTML = "Pause Carousel"
                $this.carousel('cycle')
                $is_paused = false
              }
              else {
                $pauseCarousel.innerHTML = "Play Carousel"
                $this.carousel('pause')
                $is_paused = true
              }
            })
            $($pauseCarousel).focus(function() {
              $(this).addClass('focus')
            })
    
            $($pauseCarousel).blur(function() {
              $(this).removeClass('focus')
            })
    
            setTablistHighlightBox()
    
            $( window ).resize(function() {
              setTablistHighlightBox()
            })
    
            // Add space bar behavior to prev and next buttons for SR compatibility
            $prev.attr('aria-label', 'Previous Slide')
            $prev.keydown(function(e) {
              var k = e.which || e.keyCode
              if (/(13|32)/.test(k)) {
                e.preventDefault()
                e.stopPropagation()
                $prev.trigger('click');
              }
            });
    
            $prev.focus(function() {
              $(this).parents('.carousel').addClass('contrast')
            })
    
            $prev.blur(function() {
              $(this).parents('.carousel').removeClass('contrast')
            })
    
            $next.attr('aria-label', 'Next Slide')
            $next.keydown(function(e) {
              var k = e.which || e.keyCode
              if (/(13|32)/.test(k)) {
                e.preventDefault()
                e.stopPropagation()
                $next.trigger('click');
              }
            });
    
            $next.focus(function() {
              $(this).parents('.carousel').addClass('contrast')
            })
    
            $next.blur(function() {
              $(this).parents('.carousel').removeClass('contrast')
            })
    
            $('.carousel-inner a').focus(function() {
              $(this).parents('.carousel').addClass('contrast')
            })
    
             $('.carousel-inner a').blur(function() {
              $(this).parents('.carousel').removeClass('contrast')
            })
    
            $tabs.each(function () {
              var item = $(this)
              if(item.hasClass('active')) {
                item.attr({ 'aria-selected': 'true', 'tabindex' : '0' })
              }else{
                item.attr({ 'aria-selected': 'false', 'tabindex' : '-1' })
              }
            })
          })
    
          var slideCarousel = $.fn.carousel.Constructor.prototype.slide
          $.fn.carousel.Constructor.prototype.slide = function (type, next) {
            var $element = this.$element
              , $active  = $element.find('[role=tabpanel].active')
              , $next    = next || $active[type]()
              , $tab
              , $tab_count = $element.find('[role=tabpanel]').size()
              , $prev_side = $element.find('[data-slide="prev"]')
              , $next_side = $element.find('[data-slide="next"]')
              , $index      = 0
              , $prev_index = $tab_count -1
              , $next_index = 1
              , $id
    
            if ($next && $next.attr('id')) {
              $id = $next.attr('id')
              $index = $id.lastIndexOf("-")
              if ($index >= 0) $index = parseInt($id.substring($index+1), 10)
    
              $prev_index = $index - 1
              if ($prev_index < 1) $prev_index = $tab_count - 1
    
              $next_index = $index + 1
              if ($next_index >= $tab_count) $next_index = 0
            }
    
            $prev_side.attr('aria-label', 'Show slide ' + ($prev_index+1) + ' of ' + $tab_count)
            $next_side.attr('aria-label', 'Show slide ' + ($next_index+1) + ' of ' + $tab_count)
    
    
            slideCarousel.apply(this, arguments)
    
          $active
            .one('bsTransitionEnd', function () {
              var $tab
    
              $tab = $element.find('li[aria-controls="' + $active.attr('id') + '"]')
              if ($tab) $tab.attr({'aria-selected':false, 'tabIndex': '-1'})
    
              $tab = $element.find('li[aria-controls="' + $next.attr('id') + '"]')
              if ($tab) $tab.attr({'aria-selected': true, 'tabIndex': '0'})
    
           })
          }
    
         var $this;
         $.fn.carousel.Constructor.prototype.keydown = function (e) {
    
         $this = $this || $(this)
         if(this instanceof Node) $this = $(this)
    
         function selectTab(index) {
           if (index >= $tabs.length) return
           if (index < 0) return
    
           $carousel.carousel(index)
           setTimeout(function () {
                $tabs[index].focus()
                // $this.prev().focus()
           }, 150)
         }
    
         var $carousel = $(e.target).closest('.carousel')
          , $tabs      = $carousel.find('[role=tab]')
          , k = e.which || e.keyCode
          , index
    
          if (!/(37|38|39|40)/.test(k)) return
    
          index = $tabs.index($tabs.filter('.active'))
          if (k == 37 || k == 38) {                           //  Up
            index--
            selectTab(index);
          }
    
          if (k == 39 || k == 40) {                          // Down
            index++
            selectTab(index);
          }
    
          e.preventDefault()
          e.stopPropagation()
        }
        $(document).on('keydown.carousel.data-api', 'li[role=tab]', $.fn.carousel.Constructor.prototype.keydown);

    $(document).on('shown.bs.modal', '.modal', function () {
      var zIndex = 1040 + (10 * $('.modal:visible').length);
      $(this).css('z-index', zIndex);
      setTimeout(function() {
          $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
      }, 0);

      $('#onboarding-slides').removeAttr('role aria-labelledby');
      $('.carousel-aside-pause').remove();
      $('#id_title').remove();
      $('.item').removeAttr('aria-labelledby');
      $('#id_desc').text('This carousel is a set of slides containing images and information. Use the Previous and Next buttons or the Navigation dots to change the displayed slide.');
      $('.carousel-indicators li').removeAttr('aria-selected');
    });

    $(document).on('show.bs.modal', '.modal', function() {
      $('.modal-backdrop:first').addClass('modal-backdrop--first');
    });
    $(document).on('hidden.bs.modal', '.modal', function() {
      $('.modal-backdrop').removeClass('modal-backdrop--first');
    });

    // onboarding carousel
    $('#onboarding-slides').carousel({
      interval: false,
      wrap: false
    })
    .on('slid.bs.carousel', function () {
      if ($('.item:first').hasClass('active')) {
        $('.carousel__control-wrap .left').addClass('hidden');
        $('.carousel__control-wrap .right').removeClass('hidden');
        $('.carousel__control-wrap .btn--go-to-record').addClass('hidden');
      } else if ($('.item:last').hasClass('active')) {
        $('.carousel__control-wrap .left').removeClass('hidden');
        $('.carousel__control-wrap .right').addClass('hidden');
        $('.carousel__control-wrap .btn--go-to-record').removeClass('hidden');
      } else {
        $('.carousel__control-wrap .left').removeClass('hidden');
        $('.carousel__control-wrap .right').removeClass('hidden');
        $('.carousel__control-wrap .btn--go-to-record').addClass('hidden');
      }

      $('.carousel__control-wrap a').removeAttr('aria-label');

    }).on('slide.bs.carousel', function () {
      $('.carousel__control-wrap a').removeAttr('aria-label');
      setTimeout(function() {
        var item = $('.carousel-indicators li');
        if(item.hasClass('active')) {
          item.removeAttr('aria-selected');
        }
      }, 1000);
    });

    $('.item a').on('focus', function() {
      $('.item').removeAttr('role');
      $('.carousel-inner').removeAttr('aria-live');
      $(this).on('blur', function() {
        $('.item').attr('role', 'tabpanel');
      });
    });
    $('.carousel__control-wrap .btn').on('click', function() {
      $('.carousel-inner').attr('aria-live', 'polite');
    });
    $('.carousel-indicators li').on('focus', function() {
      $('.carousel-inner').attr('aria-live', 'polite');
    });

    $('.carousel').bcSwipe({ threshold: 50 });

    $('.carousel__control-wrap .right').on('click', function() {
      var $this = $(this);
      $this.data('clicked', true);
      setTimeout(function() {
        if($this.data('clicked') && $this.hasClass('hidden')) {
          $('.carousel__control-wrap .btn--go-to-record').focus();
        }
      }, 700);
    });

    // get carousel count on modal close
    $('body').on('hidden.bs.modal', '#modalOnboarding', function() {
      var carouselCount = $('.item.active').index() + 1;
      console.log(carouselCount);
    });

    $(document).ready(function() {
      var carouselCount = $('.item.active').index() + 1;
      $('.carousel-indicators li .sr-only').each(function() {
        $(this).text('Slide ' + carouselCount);
        carouselCount++;
      });
      $('.carousel__control-wrap a').removeAttr('aria-label');
    });

  });
}());
(function() {

    'use strict';

    $(document).on('click', '.close--static-message-alert', function () {
      $(this).parents('.alert').slideUp(300); // for FED copy only
      cardClose(); // for FED copy only
    });

    function cardClose(){
      if($('.close--static-message-alert').parents('.alert').hasClass('alert--get-started')) {
        if($('.alert.alert--about-shs').attr('style') || $('.alert.alert--about-shs').length === 0) {
          $('.link__label').first().focus();
        } else {
          $('.alert--about-shs a').focus();
        }
      } else if ($('.close--static-message-alert').parents('.alert').hasClass('alert--about-shs')) {
        $('.link__label').first().focus();
      }          
    }

})();