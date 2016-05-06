# Node modules
mongoose = require 'mongoose'
Schema   = mongoose.Schema

PersonSchema = new mongoose.Schema
  username:
    type: String,
    required: true
    trim: true
    unique: true
  name:
    type: String,
    required: true
    trim: true
  email:
    type: String,
    required: true
    trim: true
  active:
    type: Boolean,
    default: true
  rawData:
    type: Object,
    default: {}
  created_at:
    type: Date
    default: Date.now

mongoose.model 'Person', PersonSchema