package examples.posts;

import io.karatelabs.junit6.Karate;

class PostsRunner {

    @Karate.Test
    Karate testPosts() {
        return Karate.run("posts").relativeTo(getClass());
    }
}
