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
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-35, 30, 25);
            // 旋转相机对象
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置渲染器背景
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置渲染大小
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 开启阴影
            renderer.shadowMapEnabled = true;

            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(600, 200, 20, 20),
                new THREE.MeshLambertMaterial({color: 0xffffff})
            );
            // 开启阴影
            plane.receiveShadow = true;
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, -5, 0);
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({color: 0xff3333})
            );
            // 开启阴影
            cube.castShadow = true;
            // 设置位置
            cube.position.set(-4, 3, 0);
            scene.add(cube);

            // 创建球体
            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 20, 20),
                new THREE.MeshLambertMaterial({color: 0x7777ff})
            );
            // 开启阴影
            sphere.castShadow = true;
            // 设置球体位置
            sphere.position.set(20, 0, 2);
            scene.add(sphere);

            // 创建环境光
            var ambiColor = "#1c1c1c";
            var ambientLight = new THREE.AmbientLight(ambiColor);
            scene.add(ambientLight);


            var target = new THREE.Object3D();
            target.position = new THREE.Vector3(5, 0, 0);

            // 创建方向光
            var pointColor = "#ff5808";
            var directionalLight = new THREE.DirectionalLight(pointColor);
            directionalLight.position.set(-40, 60, -10);
            directionalLight.castShadow = true;
            directionalLight.shadowCameraNear = 2;
            directionalLight.shadowCameraFar = 200;
            directionalLight.shadowCameraLeft = -50;
            directionalLight.shadowCameraRight = 50;
            directionalLight.shadowCameraTop = 50;
            directionalLight.shadowCameraBottom = -50;

            directionalLight.distance = 0;
            directionalLight.intensity = 0.5;
            directionalLight.shadowMapHeight = 1024;
            directionalLight.shadowMapWidth = 1024;
            scene.add(directionalLight);


            var sphereLightMesh = new THREE.Mesh(new THREE.SphereGeometry(0.2),
                new THREE.MeshLambertMaterial({color: 0xac6c25})
            );
            sphereLightMesh.castShadow = true;

            sphereLightMesh.position = new THREE.Vector3(3, 20, 3);

            scene.add(sphereLightMesh);


            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var invert = 1;
            var phase = 0;
            var controls = new function () {
                this.rotationSpeed = 0.03;
                this.bouncingSpeed = 0.03;
                this.ambientColor = ambiColor;
                this.pointColor = pointColor;
                this.intensity = 0.5;
                this.distance = 0;
                this.exponent = 30;
                this.angle = 0.1;
                this.debug = false;
                this.castShadow = true;
                this.onlyShadow = false;
                this.target = "Plane";
            }

            var gui = new dat.GUI();
            gui.addColor(controls, "ambientColor").onChange(function(e) {
                ambientLight.color = new THREE.Color(e);
            });
            gui.addColor(controls, "pointColor").onChange(function(e) {
                directionalLight.color = new THREE.Color(e);
            });
            gui.add(controls, "intensity", 0, 5).onChange(function(e) {
                directionalLight.intensity = e;
            });
            gui.add(controls, "distance", 0, 200).onChange(function(e) {
                directionalLight.distance = e;
            });
            gui.add(controls, "debug").onChange(function(e) {
                directionalLight.shadowCameraVisible = e;
            });
            gui.add(controls, "castShadow").onChange(function(e) {
                directionalLight.castShadow = e;
            });
            gui.add(controls, "onlyShadow").onChange(function(e) {
                directionalLight.onlyShadow = e;
            });
            gui.add(controls, "target", ['Plane', 'Sphere', 'Cube']).onChange(function(e) {
                console.log(e);
                switch (e) {
                    case "Plane":
                        directionalLight.target = plane;
                        break;
                    case "Sphere":
                        directionalLight.target = sphere;
                        break;
                    case "Cube":
                        directionalLight.target = cube;
                        break;
                }
            });

            render();

            function render() {
                stats.update();

                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpeed;
                sphere.position.x = 20 +(10 * (Math.cos(step)));
                sphere.position.y = 2 +(10 * Math.abs(Math.sin(step)));

                sphereLightMesh.position.x = 10 +(26 * (Math.cos(step / 3)));
                sphereLightMesh.position.y = +(27 * (Math.sin(step / 3)));
                sphereLightMesh.position.z = -8;

                directionalLight.position = sphereLightMesh.position;

                requestAnimationFrame(render);
                renderer.render(scene, camera);
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