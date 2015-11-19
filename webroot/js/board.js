$(document).ready(function() {

    // dragging
    var flowElems = document.getElementsByClassName('flow-container');
    var flowElemsArr = [].slice.call(flowElems);

    dragula(flowElemsArr, {
        revertOnSpill: true,
        invalid: function (el) {
            // return el.tagName === 'LABEL';
        }
    }).on('drag', function (el, source) {
        // nothing
    }).on('drop', function (el, target, source) {
        var sourceStatus = $(source).attr('data-flow-status');
        var targetStatus = $(target).attr('data-flow-status');
        var objectId = $(el).attr('data-flow-id');

        if (sourceStatus != targetStatus) {
            var postData = {
                data: {
                    id: objectId,
                    ticket_status: targetStatus
                }
            };

            $('.secondacolonna label.tickets').addClass('save');
            $.ajax({
                type: "POST",
                url: BEDITA.base + 'tickets/saveStatus',
                data: postData,
                dataType: 'json'
            }).done(function(response) {
                // console.log(response);
            }).error(function(jqXHR, textStatus, errorThrown) {
                $(source).append($(el));
                try {
                    if (jqXHR.responseText) {
                        var data = JSON.parse(jqXHR.responseText);
                        if (typeof data != 'undefined' && data.errorMsg && data.htmlMsg) {
                            $('#messagesDiv').empty();
                            $('#messagesDiv').html(data.htmlMsg).triggerMessage('error');
                        }
                    }
                } catch (e) {
                    console.error("Missing responseText or it's not a valid json");
                }
            }).always(function() {
                $('.secondacolonna label.tickets').removeClass('save');
            });
        }
    });


    // more UI
    $('.js-flow-item').mouseenter(function() {
        $(this).addClass('active-item');
    }).mouseleave(function() {
        $(this).removeClass('active-item');
    });
    
    $('.js-flow-item').on( "dblclick", function() {
        var url = $(this).find('.js-edit-btn').attr('href');
        location.href = url;
    });


    // toolbar
    $('.js-toolbar-severity input[type=checkbox]').change(function() {
        $(".js-toolbar-severity input[type=radio]").prop('checked', $('.js-toolbar-severity input[type=checkbox]').length == $('.js-toolbar-severity input[type=checkbox]:checked').length);
        updateSeverityView();
    });

    $(".js-toolbar-severity input[type=radio]").change(function() {
        $('.js-toolbar-severity input[type=checkbox]').prop('checked', $(this).prop("checked"));
        updateSeverityView();
    });

    function updateSeverityView() {
        $('.js-toolbar-severity input[type=checkbox]').not(':checked').each(function() {
            $('.js-item-severity.' + $(this).attr('value')).parents('.js-flow-item').hide();
        });
        $('.js-toolbar-severity input[type=checkbox]:checked').each(function() {
            $('.js-item-severity.' + $(this).attr('value')).parents('.js-flow-item').show();
        });
    }

});

