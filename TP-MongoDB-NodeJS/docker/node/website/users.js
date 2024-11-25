$(function () {
    // remplissage de la page avec la liste des users
    async function getUsers() {
        // on prÃ©pare l'entete de la requete get
        const options = {
            method: 'GET',
            mode: 'cors',
            headers: {
                "Content-Type": "application/json"
            }
        };

        reponse = await fetch('http://localhost:10041/users', options);
        users = await reponse.json();

        // on parcourt les users
        users.forEach(user => {
            $("#users").append("<li>" + user.username + "</li>")
        });
    }
    getUsers();

    async function addUser(name) {
        // on prÃ©pare l'entete de la requete post
        options2 = {
            method: 'POST',
            mode: 'cors',
            headers: {
                "Content-Type": "application/json"
            },
            body : JSON.stringify({username : name})
        };

        reponse = await fetch('http://localhost:10041/addUser?username='+name, options2);
        rep = await reponse.json();
        console.log(rep);
        $("#users").append("<li>" + name + "</li>")
    }

    $("#valider").on("click", function () {
        let username = $("#ajout_user").val();
        console.log("username="+username);
        addUser(username);
        
    });

})

    