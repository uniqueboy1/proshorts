import express from "express";
let app = express();

app.get("/", (req, res) => {
  res.status(200).send("Home page");
});

app.get("/users", (req, res) => {
  res.status(200).json([
    { name: "John", age: 24 },
    { name: "Wick", age: 34 },
    { name: "Bimal", age: 54 },
  ]);
});

app.listen(400, () => {
  console.log("server is running");
});
