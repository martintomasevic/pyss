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

    $("#showDataButton").on("click", function(){
        var email = document.getElementById("username").innerHTML;
        $.post("/allData",
            {
                email: email
            },
            function(data, status){
                document.getElementById("allData").innerHTML = data;
            });
    });

});