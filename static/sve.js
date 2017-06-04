$( document ).ready(function() {
    console.log( "ready!" );

    $("#logOutButton").on("click", function(){
    console.log("click");
        window.location.href = "/logout";
    });

    $("#showEmailInAlert").on("click", function(){
        var email = document.getElementById("username").innerHTML;
        $.post("/test",
            {
                email: email,
            },
            function(data, status){
                alert("Data: " + data + "\nStatus: " + status);
            });
    });


    var podatki = {"schoolid": 1};

    $("#showDataButton").on("click", function(){
        $.post("/allData", podatki,
            function(data, status){
                console.log(data, status);
                prikazi_ostale(data.ostali);
                eventi = data.eventi;
                prikazi_evente(data.eventi);
            });
    });


    function prikazi_ostale(ostali){
        for (var i=0; i<ostali.length;i++){
            $("#ostali").append("<tr><td>" + ostali[i].ime + "</td><td>" + ostali[i].prezime + "</td><td>" + ostali[i].rola + "</td></tr>").html()
        }
    }

    var eventi = null;

    function prikazi_evente(eventi){
        $.each(eventi, function(k, v){
            event = v;
            id = k;
            $("#ostali").append("<tr><td>" + event.pocetak + "</td><td>" + event.kraj + "</td><td class='expandme' id='eventid-" + id + "'>" + event.ime + "</td></tr>").html()

        });

    }

    $(document).on('mouseover', ".expandme", function(event){
        var id = parseInt($(this).prop("id").split("-")[1]);
        $("#details").text("");

        var podacicice = eventi[id].podacice;
        $("#details").text(podacicice);
        var x = event.pageX - event.offsetX + 50;
        var y = event.pageY - event.offsetY + 50;

        $("#details").css("display", "block");
        $("#details").css("top", y + "px");
        $("#details").css("left", x + "px");
    });

    $(document).on('mouseleave', ".expandme", function(event){
        $("#details").css("display", "none");
    });

});