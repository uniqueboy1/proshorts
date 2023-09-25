import express, { urlencoded } from "express";
import mongoose from "mongoose";
import "dotenv/config.js";
import multer from "multer";
import VideoRouter from "./routes/add_videos.js";
import profileRouter from "./routes/profile.js";
import * as fs from "fs/promises";
import cors from "cors";
import usersRouter from "./routes/users.js";

const app = express();
app.use(express.static("uploads"));
// const corsOptions = {
//   origin: 'http://10.0.2.2:8000', // Replace with your allowed origin
//   methods: 'GET, POST, PUT, DELETE',
//   allowedHeaders: 'Content-Type, Authorization',
// };
// app.use(cors(corsOptions));
app.use(express.json());
app.use(urlencoded({ extended: true }));
app.use("/videos", VideoRouter);
app.use("/profiles", profileRouter);
app.use("/users", usersRouter);

// Set up multer storage to store videos
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/videos"); // Specify the directory to save the uploaded videos
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Generate a unique filename for each uploaded video
  },
});

// Create a multer instance with the storage configuration
const upload = multer({ storage });

app.post("/upload_video", upload.single("video"), (req, res) => {
  res.send({ success: true, message: "Videos uploaded successfully" });
});

// Set up multer storage to store profile photo
const profileStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/profiles"); // Specify the directory to save the uploaded videos
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Generate a unique filename for each uploaded video
  },
});

// Create a multer instance with the storage configuration
const profileUpload = multer({ storage: profileStorage });

app.post("/upload_profile", profileUpload.single("profile"), (req, res) => {
  res.send({ success: true, message: "Profile Photo uploaded successfully" });
});

// deleting profile photo

async function deleteProfilePhoto(req, res) {
  try {
    const { profile_name } = req.params;
    let imagePath = `uploads/profiles/${profile_name}`;
    console.log(imagePath);
    await fs.unlink(imagePath);
    res.json({
      success: true,
      message: "Profile Photo deleted successfully",
    });
  } catch (error) {
    res.json({
      success: false,
      message: error,
    });
  }
}
app.delete("/delete_profile_photo/:profile_name", deleteProfilePhoto);

// Set up multer storage to store thumbnail
const thumbnailStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/thumbnails");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

// Create a multer instance with the storage configuration
const thumbnailUpload = multer({ storage: thumbnailStorage });

app.post(
  "/upload_thumbnail",
  thumbnailUpload.single("thumbnail"),
  (req, res) => {
    res.send({ success: true, message: "Thumbnail uploaded successfully" });
  }
);

app.get("/", (req, res) => {
  res.send("this is home page ");
});

app.listen(8000, async () => {
  // connecting to mongo db local database
  try {
    await mongoose.connect(process.env.DATABASE_URL);
    console.log("connected to database");
  } catch (error) {
    console.log("error connecting to database", error);
  }
  console.log("server is working");
});
