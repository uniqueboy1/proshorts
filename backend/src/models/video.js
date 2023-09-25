import mongoose from "mongoose";

let schema = new mongoose.Schema({
  userInformation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "users",
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  keywords: {
    type: [],
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  videoMode: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  uploadDate: {
    type: Date,
    default: Date.now,
  },
  likeCount: {
    type: Number,
    default: 0,
  },
  dislikeCount: {
    type: Number,
    default: 0,
  },
  comments: {
    type: [
      {
        id: {
          type: mongoose.Types.ObjectId,
          // Automatically generate ObjectId for each comment
          default: mongoose.Types.ObjectId,
        },
        userInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "users",
        },
        comment: String,
        likeCount: {
          type: Number,
          default: 0,
        },
        dislikeCount: {
          type: Number,
          default: 0,
        },
        replies: {
          type: [
            {
              id: {
                type: mongoose.Types.ObjectId,
                default: mongoose.Types.ObjectId, // Automatically generate ObjectId for each comment
              },
              userInformation: {
                type: mongoose.Schema.Types.ObjectId,
                ref: "users",
              },
              likeCount: {
                type: Number,
                default: 0,
              },
              dislikeCount: {
                type: Number,
                default: 0,
              },
              reply: String,
            },
          ],
        },
      },
    ],
  },
  viewsCount: {
    type: Number,
    default: 0,
  },
  shareCount: {
    type: Number,
    default: 0,
  },
  lengthOfVideo: {
    type: Number,
    required: true,
  },
  videoSize: {
    type: Number,
    required: true,
  },
  videoPath: {
    type: String,
    required: true,
  },
  thumbnailName: {
    type: String,
    required: true,
  },
  reportMessage: {
    type: [
      {
        userInformation: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "users",
          required: true,
        },
        message: {
          type: String,
          required: true,
        },
      },
    ],
  },
});

let uploaded_videos = mongoose.model("uploaded_videos", schema);

export default uploaded_videos;
