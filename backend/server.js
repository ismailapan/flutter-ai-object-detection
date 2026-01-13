const express = require('express');
const cors = require('cors');
const db = require('./firebase');

const app = express();
app.use(cors());
app.use(express.json());

app.get("/fruit/:label", async (req, res) => {
  const label = req.params.label;

  try {
    const doc = await db.collection("fruit").doc(label).get();

    if (!doc.exists) {
      return res.status(404).json({ error: "Fruit not found" });
    }

    res.json(doc.data());
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

app.use((req, res, next)=> {
  console.log("Incoming req =>", req.method, req.url);
  next();
});

app.listen(3000, '0.0.0.0', () => {
  console.log("API running on http://localhost:3000");
});