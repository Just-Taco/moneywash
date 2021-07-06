$(function () {
    function display(bool) {
        if (bool) {
            $("body").fadeIn(1000);
        } else {
            $("body").fadeOut(1000);
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;


        $("#washingCost").html(item.currentWashCost + "$")
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
   

    

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://rc_moneyWash/exit', JSON.stringify({})); 
            return
        }
    };
    $("#close").click(function () {
        $.post('http://rc_moneyWash/exit', JSON.stringify({})); 
        return
    })


    
})