<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <title>Insert title here</title>

    <style>
        body{
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        $(function() {

            // 创建场景
            var scene = new THREE.Scene();

            // 创建相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            camera.position.set(-30, 40, 30);
            camera.lookAt(scene.position);
            scene.add(camera);

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE);
            renderer.setSize(window.innerWidth, window.innerHeight);

            var axes = new THREE.AxisHelper(20);// 创建坐标轴对象
            scene.add(axes);

            // 创建平面
            var planeGeometry = new THREE.PlaneGeometry(60, 20);
            // 创建平面外观颜色
            var planeMaterial = new THREE.MeshBasicMaterial({
                color: 0xcccccc
            });
            // 将平面内容放置到网格中
            var plane = new THREE.Mesh(planeGeometry, planeMaterial);
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.x = 15;
            plane.position.y = 0;
            plane.position.z = 0;
            scene.add(plane);

            // 创建立方体
            var cubeGeometry = new THREE.CubeGeometry(4, 4, 4);
            var cubeMaterial = new THREE.MeshBasicMaterial({
                color: 0xff0000,
                // 把wireframe线框属性设置为true，默认为false
                wireframe: true
            });
            var cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
            cube.position.set(-4, 3, 0);
            scene.add(cube);

            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 20, 20),
                new THREE.MeshBasicMaterial({
                    color: 0x7777ff,
                    // 把wireframe线框属性设置为true，默认为false
                    wireframe: true
                })
            );
            sphere.position.set(20, 4, 2);
            scene.add(sphere);

            $("#WebGL-output").append(renderer.domElement);
            renderer.render(scene, camera);


        })

    </script>

</head>
<body>

    <div id="WebGL-output"></div>

</body>
</html>