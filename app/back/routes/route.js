'use strict';

const express = require('express');
const router = express.Router();
const cors = require('cors');
const request = require('request');
const User = require('../model/User.js').default;

require('dotenv').config();
const DATABASE_API_ENDPOINT = process.env.DATABASE_API_ENDPOINT;
console.log('DATABASE_API_ENDPOINT', DATABASE_API_ENDPOINT);

/**
 * Option method request handler.
 */
router.options('*', (req, res) => res.sendStatus(200));

/**
 * Get a user.
 */
router.get('/api/user', cors(), (req, res, next)  => {
  /**
   * User data.
   * For simplicity, the data is embedded.
   */
  const users = [
    new User(999999, "Default"),
    new User(1, "Adam"),
    new User(2, "Ben"),
    new User(3, "Chris")
  ];

  const id = parseInt(req.query.id);

  (async () => {
    const user = users.find(u => u.id === id);
    if (!user) {
      res.send(JSON.stringify(users[0]));
      return;
    }

    const purchaseList = await getUserPurchaseList(id);
    user.setPurchaseList(purchaseList);
  
    res.send(JSON.stringify(user));
  })().catch(next);
});

/**
 * Get user purchase list by user ID from database API.
 */
async function getUserPurchaseList(userId) {
  const url = `${DATABASE_API_ENDPOINT}/api/userpurchase?uid=${userId}`;
  const method = 'GET';
  const timeout = 10000;
  const requestOption = { url, method, timeout };
  
  const response = await doRequest(requestOption)
    .then(json => JSON.parse(json))
    .catch(err => []);

  return response;
}

/**
 * Request helper.
 */
async function doRequest(option) {
  return new Promise((resolve, reject) => {
    request(option, (err, res, body) => {
      if (err || res.statusCode !== 200) reject(err);
      resolve(body);
    });
  });
}

module.exports = router;
