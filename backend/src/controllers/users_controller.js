import profile from "../models/profile.js";
import users from "../models/users.js";
import upload_videos from "../models/video.js";
// if field is not present in the query it will have value undefined
class UsersController {
  async addUser(req, res) {
    console.log(req.body);

    try {
      let response = await users.create(req.body);
      res.json({
        success: true,
        message: "User added Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async allUsers(req, res) {
    try {
      // const { populateProfile, populateNice } = req.query;
      // console.log(populateProfile, populateNice);
      let response = await users
        .find()
        .populate("profileInformation")
        .populate({
          path: "followers.userInformation",
          populate: {
            path: "profileInformation",
          },
        });
      console.log("response");
      res.json({
        success: true,
        message: "All users",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async followingVideos(req, res) {
    console.log("following videos");
    try {
      const { id } = req.params;
      let following = [];
      let response = await users.findById(id).select("following");
      for(let userInformation of response.following){
        following.push(userInformation['userInformation'])
      }
      response = await upload_videos
        .find({
          videoMode : "public",
          userInformation: {
            $in: following,
          },
        })
        .populate({
          path : "userInformation",
          populate : {
            path : "profileInformation"
          }
        })
      console.log("response");
      res.json({
        success: true,
        message: "following videos",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readUserById(req, res) {
    try {
      const { id } = req.params;
      const response = await users
        .findById(id)
        .populate("profileInformation")
        .populate({
          path: "followers.userInformation",
          populate: {
            path: "profileInformation",
          },
        });
      console.log(response);
      res.json({
        success: true,
        message: "One user",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async checkValueInArray(req, res) {
    try {
      const { field, value } = req.params;
      const response = await users.find({
        [field]: {
          $in: value,
        },
      });
      console.log(response);
      res.json({
        success: true,
        message: "Value in array",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async returnUserField(req, res) {
    try {
      const { search_field, search_value, return_field } = req.params;
      let response = null;
      if (return_field == "followers") {
        response = await users
          .find({
            [search_field]: search_value,
          })
          .select(return_field)
          .populate({
            path: "followers.userInformation",
            populate: {
              path: "profileInformation",
            },
          });
      } else if (return_field == "following") {
        response = await users
          .find({
            [search_field]: search_value,
          })
          .select(return_field)
          .populate({
            path: "following.userInformation",
            populate: {
              path: "profileInformation",
            },
          });
      } else {
        response = await users
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
      res.send({ success: false, message: error });
    }
  }

  async topUser(req, res) {
    try {
      const response = await users
        .find({
          profileInformation: {
            $exists: true,
          },
        })
        .sort({
          followers: -1,
        })
        .limit(10)
        .populate("profileInformation");
      console.log(response);
      res.json({
        success: true,
        message: "One user",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readUserByField(req, res) {
    console.log("read user field");
    try {
      const { field, value } = req.params;
      console.log(field, value);
      const response = await users
        .find({ [field]: value })
        .populate("profileInformation")
        .populate({
          path: "followers.userInformation",
          populate: {
            path: "profileInformation",
          },
        })
        .populate({
          path: "watchLater.videoInformation",
        })
        .populate({
          path: "watchHistory.videoInformation",
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

  // async readUserByTwoField(req, res) {
  //   try {
  //     const { field1, value1, field2, value2 } = req.params;
  //     console.log(field1, value1, field2, value2);
  //     const response = await users.find({[field1] : value1, [field2] : value2}).populate("profileInformation").populate({
  //       "path" : "followers.userInformation",
  //       populate : {
  //         "path" : "profileInformation"
  //       }
  //     });
  //     console.log(response);
  //     res.json({
  //       success: true,
  //       message: "Video",
  //       response,
  //     });
  //   } catch (error) {
  //     res.send({ success: false, message: error });
  //   }
  // }

  async editUserById(req, res) {
    try {
      const { id } = req.params;
      let response = await users.findByIdAndUpdate(id, req.body);
      res.json({
        success: true,
        message: "User Updated Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async checkValueExistInArray(req, res) {
    console.log("checking value");
    try {
      const { userId, field, checkValue, key } = req.params;
      let response = await users.findOne(
        {
          _id: userId,
        },
        {
          [field]: {
            $elemMatch: {
              [key]: checkValue,
            },
          },
        }
      );
      const valueExists =
        response && response[field] && response[field].length > 0;
      res.json({
        success: true,
        message: "Checking value",
        response: valueExists,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async editUserArrayField(req, res) {
    console.log("edit user array field");
    try {
      const { id, field } = req.params;
      let response = await users.findByIdAndUpdate(id, {
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

  async deleteUserArrayField(req, res) {
    try {
      const { id, field } = req.params;
      let response = await users.findByIdAndUpdate(id, {
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

  async deleteUserById(req, res) {
    try {
      const { id } = req.params;
      let response = await users.findByIdAndDelete(id);
      res.json({
        success: true,
        message: "User Deleted Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  // async searching(req, res){
  //   const {search_term} = req.query;
  //   const pipeline = [
  //     {
  //       $lookup: {
  //         from: "profiles",
  //         localField: "profileInformation",
  //         foreignField: "_id",
  //         as: "profileInformation",
  //       },
  //     },
  //     {
  //       $unwind: "$profileInformation",
  //     },
  //     {
  //       $match: {
  //         $or: [
  //           { "profileInformation.name": { $regex: search_term, $options: "i" } }, // Search by name (case-insensitive)
  //           { "profileInformation.username": { $regex: search_term, $options: "i" } }, // Search by username (case-insensitive)
  //           { "profileInformation.bio": { $regex: search_term, $options: "i" } }, // Search by bio (case-insensitive)
  //         ],
  //       },
  //     },
  //     {
  //       $project: {
  //         followers : 1,
  //         user : "$$ROOT",
  //         profileInformation: 1, // Exclude the profile information if not needed in the final results
  //       },
  //     },
  //   ];

  //   const response = await users.aggregate(pipeline);
  //   console.log(response);

  //   res.json({
  //         success: true,
  //         message: "User Searched Successfully",
  //         response,
  //       });
  // }

  async searchQuery(req, res) {
    console.log("search query");
    try {
      console.log(req.query);
      const { search_term, limit } = req.query;
      console.log(search_term);

      if (search_term !== "") {
        const response = await users
          .find({
            profileInformation: {
              $in: await profile
                .find({
                  $or: [
                    { name: { $regex: search_term, $options: "i" } },
                    { username: { $regex: search_term, $options: "i" } },
                    { bio: { $regex: search_term, $options: "i" } },
                  ],
                })
                .distinct("_id"),
            },
          })
          .limit(limit)
          .populate("profileInformation");
        res.json({
          success: true,
          message: "User Searched Successfully",
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
      const { search_term, followers, limit } = req.query;
      let sort = {};
      if (followers && followers === "low") {
        sort.followers = 1;
      }

      if (followers && followers == "high") {
        sort.followers = -1;
      }

      if (search_term && search_term !== "") {
        const response = await users
          .find({
            profileInformation: {
              $in: await profile
                .find({
                  $or: [
                    { name: { $regex: search_term, $options: "i" } },
                    { username: { $regex: search_term, $options: "i" } },
                    { bio: { $regex: search_term, $options: "i" } },
                  ],
                })
                .distinct("_id"),
            },
          })
          .sort(sort)
          .limit(limit)
          .populate("profileInformation");
        res.json({
          success: true,
          message: "User Searched and Filtered Successfully",
          response,
        });
      } else {
        let response = await users
          .find()
          .sort(sort)
          .limit(limit)
          .populate("profileInformation");
        res.json({
          success: true,
          message: "User filtered Successfully",
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

export default UsersController;
