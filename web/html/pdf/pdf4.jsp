<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <title>Insert title here</title>

    <script type="text/javascript">

        function init() {

            // 1、先创建场景
            var scene = new THREE.Scene();

            // 2、创建透视相机
            var camera = new THREE.PerspectiveCamera(45, 400/300, 1, 10);
            camera.position.set(0, 0, 5);
            scene.add(camera);// 添加到场景

            // 3、创建渲染器
            var renderer = new THREE.WebGLRenderer({
                // 与元素绑定
                canvas : document.getElementById("minCanvas")
            });
            renderer.setClearColor(0x000000);// 为渲染器设置背景色

            // 4、设置一个在原点处的边长为1的正方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(1, 2, 3),
                new THREE.MeshBasicMaterial({
                    color : 0xff0000,
                    // 是否渲染线而非面，默认为false
                    wireframe : true
                })
            );
            scene.add(cube);// 将立方体添加到场景中

            // 渲染
            renderer.render(scene, camera);

        }

    </script>

</head>
<body onload="init()">

    <canvas id="minCanvas" width="400px" height="300px"></canvas>

</body>
</html>