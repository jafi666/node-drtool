# Node modules
mongoose = require 'mongoose'
Schema   = mongoose.Schema

TodoSchema = new mongoose.Schema
  name:
    type: String,
    required: true
    trim: true
  completed:
    type: Boolean,
    required: true
    default: false
  note:
    type: String,
    required: true
    trim: true
    default: ''
  updated_at:
    type: Date
    default: Date.now

mongoose.model 'Todo', TodoSchema