<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <title>Insert title here</title>

    <script type="text/javascript">

        function init() {

            var scene = new THREE.Scene();// 创建场景

            var camera = new THREE.OrthographicCamera(-2, 2, 1.5, -1.5, 1, 10);// 创建3D正交投影照相机
            camera.position.set(4, -3, 5);
            camera.lookAt(new THREE.Vector3(0, 0, 0));
            scene.add(camera);// 添加相机到场景中

            // 创建一个x、y、z方向长度分别为1、2、3的长方体，并将其设置为红色
            var cube = new THREE.Mesh(new THREE.CubeGeometry(1, 1, 1),
                new THREE.MeshBasicMaterial({
                    color : 0xff0000,
                    wireframe : true
                })
            );
            scene.add(cube);// 将立方体添加到场景中

            // 创建渲染器并与元素绑定
            var renderer = new THREE.WebGLRenderer({
                canvas : document.getElementById("minCanvas")
            });
            renderer.setClearColor(0x000000);// 为渲染器设置背景色

            renderer.render(scene, camera);// 渲染

        }

    </script>

</head>
<body onload="init()">

    <canvas class="" id="minCanvas" width="400px;" height="300px;"></canvas>

</body>
</html>