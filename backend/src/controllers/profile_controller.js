import profile from "../models/profile.js";
import * as fs from "fs/promises";

class ProfileController {
  async addProfile(req, res) {
    console.log(req.body);
    try {
      let response = await profile.create(req.body);
      res.json({
        success: true,
        message: "Profile created successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async allProfiles(req, res) {
    try {
      let response = await profile.find();
      res.json({
        success: true,
        message: "All Profiles",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async checkFieldExistance(req, res) {
    try {
      let { field, value } = req.params;
      const query = {
        [field]: value,
      };
      let response = await profile.find(query);
      res.json({
        success: true,
        message: "Some Profiles",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readProfilesById(req, res) {
    try {
      const { id } = req.params;
      const response = await adventure_sites.findById(id);
      res.json({
        success: true,
        message: "One Adventure Sites",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async readProfilesByField(req, res) {
    try {
      const { field, value } = req.params;
      const response = await profile.find({ [field] : value });
      res.json({
        success: true,
        message: "Profile",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async editProfilesById(req, res) {
    try {
      const { id } = req.params;
      const response = await profile.findByIdAndUpdate(id, req.body);
      res.json({
        success: true,
        message: "Profile Updated Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async deleteProfilesById(req, res) {
    let imagePath = "profiles";
    try {
      const { id } = req.params;
      let response = await profile.findByIdAndDelete(id);
      imagePath = `${imagePath}/${response.profilePhoto}`;
      await fs.unlink(imagePath);
      res.json({
        success: true,
        message: "Profile Deleted Successfully",
        response,
      });
    } catch (error) {
      res.send({ success: false, message: error });
    }
  }

  async searchQuery(req, res) {
    try {
      console.log(req.query);
      const { search_term } = req.query;
      console.log(search_term);

      if (search_term !== "") {
        let response = await profile.find({
          $or: [
            { name: { $regex: search_term, $options: "i" } },
            { username: { $regex: search_term, $options: "i" } },
            { bio: { $regex: search_term, $options: "i" } },
          ],
        });
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
      const { search_term, likeCount } = req.query;
      if (likeCount) {
        if (likeCount === "high") {
          req.query.likeCount = { $gt: 100 };
        } else {
          req.query.likeCount = { $lt: 100 };
        }
      }

      if (search_term && search_term !== "") {
        let query = req.query;
        delete query.search_term;
        console.log("delete search term");
        console.log(query);
        let response = await adventure_sites.find({
          $or: [
            { name: { $regex: search_term, $options: "i" } },
            { province: { $regex: search_term, $options: "i" } },
            { district: { $regex: search_term, $options: "i" } },
            { description: { $regex: search_term, $options: "i" } },
          ],
          ...query,
        });
        res.json({
          success: true,
          message: "Adventure Sites Searched and filtered Successfully",
          response,
        });
      } else {
        let response = await adventure_sites.find(req.query);
        res.json({
          success: true,
          message: "Adventure Sites filtered Successfully",
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

export default ProfileController;
