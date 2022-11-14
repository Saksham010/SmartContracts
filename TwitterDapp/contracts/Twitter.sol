// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Twitter {
    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    struct Message {
        uint messageId;
        string content;
        address from;
        address to;
    }

    struct User {
        address wallet;
        string name;
        uint[] userTweets;
        address[] following;
        address[] followers;
        mapping(address => Message[]) conversations;
    }

    mapping(address => User) public users;
    mapping(uint => Tweet) public tweets;

    uint256 public nextTweetId;
    uint256 public nextMessageId;

    function registerAccount(string calldata _name) external {

        //Checking if the input string is empty or not
        bytes memory bytesdata =  bytes(_name);
        require(bytesdata.length != 0,"Name cannot be an empty string");

        //Adding new user
        User storage twt = users[msg.sender];
        twt.wallet = msg.sender;
        twt.name = _name;

    }

    function postTweet(string calldata _content) external accountExists(msg.sender) {     
        
        //Storage pointers for users and tweets mapping
        Tweet storage currentTweet = tweets[nextTweetId];
        User storage currentUser = users[msg.sender];

        //Updating the data
        currentTweet.tweetId = nextTweetId;
        currentTweet.author = msg.sender;
        currentTweet.content = _content;
        currentTweet.createdAt = block.timestamp;

        //Pushing tweetId to the array
        currentUser.userTweets.push(nextTweetId);

        //Incrementing nextTweetId
        nextTweetId++;
    }

    function readTweets(address _user) view external returns(Tweet[] memory) {
        //Initializing array of tweedId of user
        uint [] memory userTweetIds = users[_user].userTweets;

        //Number of tweets
        uint _tweetNo = userTweetIds.length;

        //Array of user Tweet of length userTweetIds
        Tweet [] memory userTweets = new Tweet[](_tweetNo);

        // //Storing tweets of user in array
        for(uint i = 0; i < userTweetIds.length; i++ ){
            Tweet memory newTweet = tweets[userTweetIds[i]];
            userTweets[i] = newTweet;
        }
        
        return userTweets;
    }

    modifier accountExists(address _user) {
        User storage _account = users[_user];

        //Checking if the account exists or not
        bytes memory _accountName = bytes(_account.name);
        require(_accountName.length != 0, "This wallet does not belong to any account.");
        _;
    }

    function followUser(address _user) external {
        //Pushing _user to following array
        users[msg.sender].following.push(_user);

        //Updating follower array of _user
        users[_user].followers.push(msg.sender);

    }

    function getFollowing() external view returns(address[] memory)  {
        return users[msg.sender].following;

    }

    function getFollowers() external view returns(address[] memory) {
        return users[msg.sender].followers;
    }

    function getTweetFeed() view external returns(Tweet[] memory) {

        //Temporary tweet array for storing all tweets
        Tweet[] memory tweetList = new Tweet[](nextTweetId);

        //Storing all tweets in the array
        for(uint i =0; i < nextTweetId; i++){
            Tweet memory testTweet = tweets[i];
            tweetList[i] = testTweet;
        }

        return tweetList;
    }

    function sendMessage(address _recipient, string calldata _content) external {
        //Initializing message struct
        Message memory tempMessage = Message(nextMessageId, _content, msg.sender, _recipient);
        
        //Pushing message in caller user struct
        users[msg.sender].conversations[_recipient].push(tempMessage);

        //Pushing message into recepient user struct
        users[_recipient].conversations[msg.sender].push(tempMessage);

        //Incrementing message id
        nextMessageId++;
    }

    function getConversationWithUser(address _user) external view returns(Message[] memory) {
        return users[msg.sender].conversations[_user];
    }
}