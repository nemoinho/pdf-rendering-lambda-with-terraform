const AWS = require('aws-sdk');

const s3 = new AWS.S3({
    signatureVersion: 'v4',
    region: process.env.BUCKET_REGION
});

const s3Bucket = process.env.BUCKET;

async function generateSignedRequestAndUrl(filename, filetype) {
    const params = {
        Bucket: s3Bucket,
        Key: filename,
        Expires: 20,
        ContentType: filetype,
        ACL: 'public-read'
    };
    const expires = Date.now() + params.Expires * 1000;
    const signedRequest = await s3.getSignedUrl('putObject', params);
    return { signedRequest, expires };
}

function uniquePrefixed(filename) {
    return Date.now() + "_" + filename;
}

// module.exports is defined by the lambda environment
module.exports.handler = ({filename, filetype}) =>
    generateSignedRequestAndUrl(uniquePrefixed(filename), filetype);
