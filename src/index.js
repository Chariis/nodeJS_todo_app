const express = require('express');
const app = express();
const db = require('./persistence');
const getItems = require('./routes/getItems');
const addItem = require('./routes/addItem');
const updateItem = require('./routes/updateItem');
const deleteItem = require('./routes/deleteItem');

app.use(express.json());
app.use(express.static(__dirname + '/static'));

app.get('/items', getItems);
app.post('/items', addItem);
app.put('/items/:id', updateItem);
app.delete('/items/:id', deleteItem);

db.init().then(() => {
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, '0.0.0.0', () => console.log(`App is listening on port ${PORT}`));

}).catch((err) => {
    console.error(err);
    process.exit(1);
});

const gracefulShutdown = () => {
    db.teardown()
        .catch(() => { })
        .then(() => process.exit());
};

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);
process.on('SIGUSR2', gracefulShutdown); // Sent by nodemon
