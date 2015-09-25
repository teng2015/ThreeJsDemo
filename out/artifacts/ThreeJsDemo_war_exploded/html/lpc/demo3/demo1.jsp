<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>

    <title>Insert title here</title>

    <style>
        body {
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        $(function() {

            var stats = initStats();

            // 创建场景
            var scene = new THREE.Scene();

            // 创建透视相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-25, 30, 25);
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置渲染器背景色
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置渲染器大小
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 开启阴影
            renderer.shadowMapEnabled = true;

            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 20, 1, 1),
                new THREE.MeshLambertMaterial({color: 0xffffff})
            );
            // 开启阴影
            plane.receiveShadow = true;
            // 设置旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, 0, 0);
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({color: 0xff0000})
            );
            // 开启阴影
            cube.castShadow = true;
            // 设置立方体位置
            cube.position.set(-4, 3, 0);
            scene.add(cube);

            // 创建球体
            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 20, 20),
                new THREE.MeshLambertMaterial({color: 0x7777ff})
            );
            // 设置球体位置
            sphere.position.set(20, 0, 2);
            // 开启阴影
            sphere.castShadow = true;
            scene.add(sphere);

            // 创建环境灯光
            var ambiColor = "#0c0c0c";// 光的颜色
            var ambientLight = new THREE.AmbientLight(ambiColor);
            scene.add(ambientLight);

            // 创建聚光灯
            var spotLight = new THREE.SpotLight(0xffffff);
            // 设置聚光灯位置
            spotLight.position.set(-40, 60, -10);
            // 开启阴影
            spotLight.castShadow = true;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            var controls = new function () {
                this.rotationSpeed = 0.02;
                this.bouncingSpeed = 0.03;
                this.ambientColor = ambiColor;
            }

            var gui = new dat.GUI();
            gui.addColor(controls, 'ambientColor').onChange(function (e) {
                ambientLight.color = new THREE.Color(e);
            });

            // 渲染
            render();

            function render() {
                stats.update();
                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpeed;
                sphere.position.x = 20 + ( 10 * (Math.cos(step)));
                sphere.position.y = 2 + ( 10 * Math.abs(Math.sin(step)));

                requestAnimationFrame(render);
                renderer.render(scene,camera);
            }

            function initStats() {
                var stats = new Stats();
                stats.setMode(0);

                stats.domElement.style.position = "absolute";
                stats.domElement.style.left = "0px";
                stats.domElement.style.top = "0px";

                $("#Stats-output").append(stats.domElement);
                return stats;
            }

        });


    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>