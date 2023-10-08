import users from "../models/users.js";
import uploaded_videos from "../models/video.js";

class AddVideoController {
  async addVideo(req, res) {
    console.log(req.body);

    try {
      let response = await uploaded_videos.create(req.body);
      console.log("video upload : ", response);
      res.json({
        success: true,
        message: "Video Uploaded Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async allVideos(req, res) {
    try {
      let response = await uploaded_videos.find().populate({
        path: "userInformation",
        populate: {
          path: "profileInformation",
        },
      });
      console.log("response");
      res.json({
        success: true,
        message: "All Videos",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readVideoById(req, res) {
    try {
      const { id } = req.params;
      const response = await uploaded_videos.findById(id).populate({
        path: "userInformation",
        populate: {
          path: "profileInformation",
        },
      });
      res.json({
        success: true,
        message: "One Video",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async returnVideoField(req, res) {
    try {
      const { search_field, search_value, return_field } = req.params;
      let response = null;
      if (return_field === "comments") {
        console.log("inside comments field");
        response = await uploaded_videos
          .find({
            [search_field]: search_value,
          })
          .select(return_field)
          .populate({
            path: "comments.userInformation",
            populate: {
              path: "profileInformation",
            },
          });
      } else {
        response = await uploaded_videos
          .find({
            [search_field]: search_value,
          })
          .select(return_field);
      }

      res.json({
        success: true,
        message: "One Video",
        response,
      });
    } catch (error) {
      console.log(error);
      res.send({ success: false, message: error });
    }
  }

  async topVideos(req, res) {
    try {
      const response = await uploaded_videos
        .find()
        .sort({
          viewsCount: -1,
        })
        .limit(10)
        .populate({
          path: "userInformation",
          populate: {
            path: "profileInformation",
          },
        });
      res.json({
        success: true,
        message: "Video",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readVideoByField(req, res) {
    try {
      const { field, value } = req.params;
      console.log(field, value);
      const response = await uploaded_videos
        .find({ [field]: value })
        .populate({
          path: "userInformation",
          populate: {
            path: "profileInformation",
          },
        })
        .populate({
          path: "comments.userInformation",
          populate: {
            path: "profileInformation",
          },
        });
      console.log(response);
      res.json({
        success: true,
        message: "Video",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readVideoByTwoField(req, res) {
    try {
      const { field1, value1, field2, value2 } = req.params;
      console.log(field1, value1, field2, value2);
      const response = await uploaded_videos
        .find({ [field1]: value1, [field2]: value2 })
        .populate({
          path: "userInformation",
          populate: {
            path: "profileInformation",
          },
        });
      console.log(response);
      res.json({
        success: true,
        message: "Video",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async checkValueExistInArray(req, res) {
    console.log("checking value video");
    try {
      const { videoId, field, key, checkValue } = req.params;
      let response = null;
      if (field == "comments-replies") {
        response = await uploaded_videos
          .findOne(
            {
              _id: videoId,
            },
            {
              comments: {
                $elemMatch: {
                  [key]: checkValue,
                },
              },
            }
          )
          .populate({
            path: "comments.replies.userInformation",
            populate: {
              path: "profileInformation",
            },
          });
      } else {
        response = await uploaded_videos.findOne(
          {
            _id: videoId,
          },
          {
            [field]: {
              $elemMatch: {
                [key]: checkValue,
              },
            },
          }
        );
      }
      res.json({
        success: true,
        message: "Checking value",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async editVideoById(req, res) {
    try {
      const { id } = req.params;
      const response = await uploaded_videos.findByIdAndUpdate(id, req.body, {
        new: true,
      });
      res.json({
        success: true,
        message: "Video Updated Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async editVideoArrayField(req, res) {
    try {
      const { id, field } = req.params;
      console.log(req.body);
      let response = await uploaded_videos.findByIdAndUpdate(id, {
        $push: {
          [field]: req.body,
        },
      });
      res.json({
        success: true,
        message: `${field}'s ${req.body} Updated Successfully`,
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async updateVideoArrayField(req, res) {
    console.log("update video array field");
    try {
      const { videoId, field, updateId } = req.params;
      console.log(req.body);
      // here directly assigining req.body reset all the fields so use this technique
      const updateObject = {};
      for (const key in req.body) {
        updateObject[`${field}.$.${key}`] = req.body[key];
      }

      let response = await uploaded_videos.updateOne(
        {
          _id: videoId,
          [`${field}._id`]: updateId,
        },
        {
          $set: updateObject,
        },
        {
          new: true,
        }
      );
      res.json({
        success: true,
        message: `${field}'s ${req.body} Updated Successfully`,
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async editVideoArrayArrayField(req, res) {
    try {
      const { videoId, fieldId, field1, field2 } = req.params;
      console.log(req.body);
      let response = await uploaded_videos.updateOne(
        {
          _id: videoId,
          [`${field1}._id`]: fieldId,
        },
        {
          $push: {
            [`${field1}.$.${field2}`]: req.body,
          },
        }
      );
      res.json({
        success: true,
        message: `${field1}'s ${field2}'s ${req.body} Updated Successfully`,
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async deleteVideoArrayField(req, res) {
    try {
      const { id, field } = req.params;
      let response = await uploaded_videos.findByIdAndUpdate(id, {
        $pull: {
          [field]: req.body,
        },
      });
      res.json({
        success: true,
        message: `${field}'s ${req.body} deleted Successfully`,
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async deleteVideoById(req, res) {
    try {
      const { id } = req.params;
      let response;
      // removing from watchLater
      response = await users.updateMany(
        {},
        {
          $pull: {
            watchLater: {
              videoInformation: id,
            },
          },
        }
      );
      // removing from watchHistory
      response = await users.updateMany(
        {},
        {
          $pull: {
            watchHistory: {
              videoInformation: id,
            },
          },
        }
      );
      // removing from likedVideos
      response = await users.updateMany(
        {},
        {
          $pull: {
            likedVideos: {
              videoInformation: id,
            },
          },
        }
      );
      // removing from dislikedVideos
      response = await users.updateMany(
        {},
        {
          $pull: {
            dislikedVideos: {
              videoInformation: id,
            },
          },
        }
      );

      let comments = await uploaded_videos.findById(id).select("comments");
      console.log(comments);

      let commentsIds = comments.comments.map((comment) => comment._id);
      console.log(commentsIds);

      // deleting from likedComments
      response = await users.updateMany(
        {},
        {
          $pull: {
            likedComments: {
              $in: commentsIds,
            },
          },
        }
      );

      // deleting from dislikedComments
      response = await users.updateMany(
        {},
        {
          $pull: {
            dislikedComments: {
              $in: commentsIds,
            },
          },
        }
      );

      response = await uploaded_videos.findByIdAndDelete(id);
      res.json({
        success: true,
        message: "Video Deleted Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async searchQuery(req, res) {
    try {
      console.log(req.query);
      const { search_term, limit } = req.query;
      console.log(search_term);

      if (search_term !== "") {
        let response = await uploaded_videos
          .find({
            $or: [
              { title: { $regex: search_term, $options: "i" } },
              { description: { $regex: search_term, $options: "i" } },
              { category: { $regex: search_term, $options: "i" } },
              // it will search inside array
              {
                keywords: {
                  $elemMatch: { $regex: search_term, $options: "i" },
                },
              },
            ],
          })
          .limit(limit)
          .populate({
            path: "userInformation",
            populate: {
              path: "profileInformation",
            },
          });
        res.json({
          success: true,
          message: "Video Searched Successfully",
          response,
        });
      } else {
        res.json({ success: false, message: "No search value" });
      }
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async filterQuery(req, res) {
    try {
      const { search_term, category, likes, views, limit } = req.query;

      let query = {};
      let sort = {};
      if (category) {
        query = {
          category: {
            $in: category,
          },
        };
      }

      if (likes && likes === "low") {
        sort.likeCount = 1;
      }

      if (likes && likes == "high") {
        sort.likeCount = -1;
      }

      if (views && views === "low") {
        sort.viewsCount = 1;
      }

      if (views && views === "high") {
        sort.viewsCount = -1;
      }

      console.log(`query : ${JSON.stringify(query)}`);
      console.log(`sort : ${JSON.stringify(sort)}`);

      if (search_term && search_term !== "") {
        let response = await uploaded_videos
          .find({
            $or: [
              { title: { $regex: search_term, $options: "i" } },
              { description: { $regex: search_term, $options: "i" } },
              { category: { $regex: search_term, $options: "i" } },
              // it will search inside array
              {
                keywords: {
                  $elemMatch: { $regex: search_term, $options: "i" },
                },
              },
            ],
            ...query,
          })
          .sort(sort)
          .limit(limit)
          .populate({
            path: "userInformation",
            populate: {
              path: "profileInformation",
            },
          });
        res.json({
          success: true,
          message: "Video Searched Successfully",
          response,
        });
      } else {
        let response = await uploaded_videos
          .find(query)
          .sort(sort)
          .limit(limit)
          .populate({
            path: "userInformation",
            populate: {
              path: "profileInformation",
            },
          });
        res.json({
          success: true,
          message: "Video filtered Successfully",
          response,
        });
      }
      console.log(search_term);
      console.log(req.query);
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }
}

export default AddVideoController;
