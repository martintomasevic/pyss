$( document ).ready(function() {
    console.log( "ready!" );

    function refreshSchoolView(){
        $.get("/schools?mode=user", function(data, status){
            console.log(data);
            console.log(status);
            $("#schools").empty();
            var schools = data.schools;
            console.log(schools)
            for(var i = 0; i < schools.length; i++){
                $("#schools").append("<li>" + schools[i].name + "</li>");
            }

            var pendingSchools = data.pending_schools;
            console.log(pendingSchools);
            $("#pending_schools").empty();
            for(var i = 0; i < pendingSchools.length; i++){
                $("#pending_schools").append("<li>" + pendingSchools[i].name + "</li>");
            }
        });
    }
    refreshSchoolView();

    $("#logOutButton").on("click", function(){
    console.log("click");
        window.location.href = "/logout";
    });

    $("#showEmailInAlert").on("click", function(){
            $.get("/schools", function(data, status){
        console.log(data);
        console.log(status);
        alert(data + status);
    });
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

    $("#create_school").on('click', function(){
        $("#school_finder").css("display", "none");
        $("#school_creation").css("display", "block");
    });

    $("#school_creation").on('submit', function(event){
        event.preventDefault();
        var schoolData = $("#school_create_form").serializeArray().reduce(function(obj, item) {
            obj[item.name] = item.value;
            return obj;
        }, {});
        console.log(schoolData);
        $.post("/schools/create", schoolData, function(data, status){
            console.log(data);
            console.log(status);
            if(status == 'success') refreshSchoolView();
        });
    });

    $("#school_creation_cancel").on('click', function(){
        $("#school_creation").css("display", "none");
    });

    $("#find_school").on('click', function(){
        console.log(this + " clicked!")
        $("#school_creation").css("display", "none");
        $.get("/schools?mode=all", function(data, status){
            console.log(data);
            var schools = data.schools;
            $("#other_schools").empty();
            for(var i = 0; i < schools.length; i++){
                $("#other_schools").append("<option>" + schools[i].name + "</option>")
            }
            console.log(status);
        });
        $.get("/roles", function(data, status){
            console.log(data);
            $("#available_roles").empty();
            for(var i = 0; i < data.length; i++){
                 $("#available_roles").append("<option>" + data[i].name + "</option>")
            }
        });
        $("#school_finder").css("display", "block");
    });

    $("#school_finder").on('submit', function(event){
        event.preventDefault();
        var schoolData = $("#school_finder_form").serializeArray().reduce(function(obj, item) {
            obj[item.name] = item.value;
            return obj;
        }, {});

        $.post("/schools/apply", schoolData, function(data, status){
            console.log(data);
            console.log(status);
            alert(data + status)});
        console.log(schoolData);
    });

    $("#school_finder_cancel").on('click', function(){
        $("#school_finder").css("display", "none");
    });
});