import mongoose from "mongoose";

let schema = new mongoose.Schema({
  profilePhoto: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  username: {
    type: String,
    required: true,
  },
  bio: {
    type: String,
    required: true,
  },
  youtubeURL: {
    type: String,
  },
  instagramURL: {
    type: String,
  },
  twitterURL: {
    type: String,
  },
  portfolioURL: {
    type: String,
  },
  profileCreatedAt: {
    type: Date,
    default: Date.now
  },
  email: {
    type: String,
    required: true,
  }
  
});

let profile = mongoose.model("profiles", schema);

export default profile;
