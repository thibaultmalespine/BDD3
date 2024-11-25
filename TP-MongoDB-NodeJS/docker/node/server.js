const { log } = require('console');
const express = require('express')
const app = express();
app.use(express.json());

const http = require('http').createServer(app);
const { MongoClient, ServerApiVersion } = require("mongodb");
const url_db = "mongodb://mongodb:27017";

const client = new MongoClient(url_db, {
	serverApi: {
		version: ServerApiVersion.v1,
		strict: true,
		deprecationErrors: true,
	}
}
);


async function users(req, res) {
	
	try {
		await client.connect();
		var result = await client.db("test").collection("users").find().toArray();;
		console.log("result="+result);
		res.json(result);
	} catch(err){
		console.log("problÃ¨me users : "+err);
		res.json({message: "problÃ¨me : "+err});
	} finally {
		// on ferme la connexion Ã  la BDD quoi qu'il arrive
		await client.close();
	}
}

app.get('/users', (req, res) => {
	users(req, res);
});

async function addUser(req, res) {
	try {	
		await client.connect();
		const {username} = req.body;
		var result = await client.db("test").collection("users").insertOne({ username: username});
		console.log(result);
		res.json({message: "ajout effectuÃ© !"});
	} catch(err){
		console.log("problÃ¨me addUser : "+err);
		res.json({message: "problÃ¨me : "+err});
	} 
	finally {
		// on ferme la connexion Ã  la BDD quoi qu'il arrive
		await client.close();
	}
}

app.post('/addUser', function (req, res) {
	addUser(req, res);
});

app.get('/admins', async (req, res) => {
	await client.connect();

	var result = await client.db("test").collection("admins").find({ admin: true}).toArray();
	res.json(result);
})

app.post('/addAdmin', async (req, res) => {
	console.log("in");
	try {	
		await client.connect();
		const {username} = req.body;
		var result = await client.db("test").collection("admins").insertOne({ username: username, admin : true});
		console.log(result);
		res.json({message: "ajout effectuÃ© !"});
	} catch(err){
		console.log("problÃ¨me addUser : "+err);
		res.json({message: "problÃ¨me : "+err});
	} 
	finally {
		// on ferme la connexion Ã  la BDD quoi qu'il arrive
		await client.close();
	}
})


app.use('/', express.static('website'));

http.listen(3000, () => {
	console.log('listening on *:3000');
});
