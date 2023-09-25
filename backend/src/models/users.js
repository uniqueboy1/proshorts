import mongoose from "mongoose";

let schema = new mongoose.Schema({
  profileInformation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "profiles",
  },
  email: {
    type: String,
    required: true,
  },
  followers: {
    type: [
      {
        userInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "users",
          required: true,
        },
      },
    ],
  },
  following: {
    type: [
      {
        userInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "users",
          required: true,
        },
      },
    ],
  },
  public_videos: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },
  private_videos: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },
  watchLater: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },
  watchHistory: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },

  likedVideos: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },
  dislikedVideos: {
    type: [
      {
        videoInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "uploaded_videos",
          required: true,
        },
      },
    ],
  },
});

let users = mongoose.model("users", schema);

export default users;
