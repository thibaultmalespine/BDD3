$(function () {
    // remplissage de la page avec la liste des users
    async function getAdmins() {
        // on prÃ©pare l'entete de la requete get
        const options = {
            method: 'GET',
            mode: 'cors',
            headers: {
                "Content-Type": "application/json"
            }
        };

        reponse = await fetch('http://localhost:10041/admins', options);
        users = await reponse.json();

        // on parcourt les users
        users.forEach(user => {
            $("#admins").append("<li>" + user.username + "</li>")
        });
    }
    getAdmins();

    async function addAdmin(name) {
        // on prÃ©pare l'entete de la requete post
        options2 = {
            method: 'POST',
            mode: 'cors',
            headers: {
                "Content-Type": "application/json"
            },
            body : JSON.stringify({username : name})
        };

        reponse = await fetch('http://localhost:10041/addAdmin', options2);
        rep = await reponse.json();
        console.log(rep);
        $("#admins").append("<li>" + name + "</li>")
    }

    $("#validerAdmin").on("click", function () {
        let username = $("#ajout_admin").val();
        console.log("username="+username);
        addAdmin(username);
        
    });

})
