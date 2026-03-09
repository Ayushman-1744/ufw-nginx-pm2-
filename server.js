const express = require("express");

const app = express();
const PORT = 3000;

app.get("/api/status", (req, res) => {
    res.json({
        status: "secure",
        message: "Maachao Gateway Active"
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});