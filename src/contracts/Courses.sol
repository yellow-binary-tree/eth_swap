pragma solidity ^0.5.0;

contract Courses {
    string public name = "Web3 Coursees";
    string public symbol = "CourseES";

    struct Course {      // 在后台存储的课程内容
        address payable publisher;
        string title;
        string content;
        string answer;
        uint price;     // 单位：wei
    }

    struct CourseForPublic {     // 在前端公开的课程内容
        address payable publisher;
        string title;
        uint price;
    }

    event AddCourse (
        address publisher,
        uint index,
        string title,
        uint price
    );

    event BuyCourse (
        address buyer,
        uint index,
        string title
    );

    uint public course_num = 0;
    mapping(uint => Course) course_list;
    mapping(uint => CourseForPublic) public course_for_public_list;

    constructor() public payable {}

    function addCourse(string memory title, 
                      string memory content,
                      string memory answer,
                      uint price) public {
        Course memory new_course = Course(msg.sender, title, content, answer, price);
        CourseForPublic memory new_course_for_public = CourseForPublic(msg.sender, title, price);
        course_list[course_num] = new_course;
        course_for_public_list[course_num] = new_course_for_public;
        course_num += 1;
        emit AddCourse(msg.sender, course_num-1, title, price);
    }

    function buyCourse(uint index) public payable returns (string memory) {
        Course memory course = course_list[index];
        // 确认买家付了正确的钱给合约，合约再付钱给卖家；否则将钱退回给买家
        if (msg.value == course.price) {
            course.publisher.transfer(course.price);
            emit BuyCourse(msg.sender, index, course.title);
            return course.content;
        }
        else { 
            msg.sender.transfer(msg.value);
            return "wrong amount of ETH tokens paid!!";
        }
    }
}