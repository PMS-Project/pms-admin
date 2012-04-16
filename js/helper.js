function doBlockUI(){
        $.blockUI({ message: '<img src="img/ajax-loader.gif" />',
                css: {
                        border: 'none',
                        "background-color": 'transparent'
                }
        }); 
}

function doUnblockUI(){
        $.unblockUI();
}

function enableBlockUI(){
        // Ajax activity indicator bound 
        //to ajax start/stop document events
        $(document).ajaxStart(doBlockUI).ajaxStop(doUnblockUI); 
}

function disableBlockUI(){
        $(document).unbind('ajaxStart');
        $(document).unbind('ajaxStop');
}