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
            var stopMovingLight = false;
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
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 20, 1, 1),
                new THREE.MeshLambertMaterial({color: 0xffffff})
            );
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, 0, 0);
            // 开启阴影
            plane.receiveShadow = true;
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
            // 设置球体位置
            sphere.position.set(20, 0, 2);
            // 开启阴影
            sphere.castShadow = true;
            scene.add(sphere);

            // 创建环境光
            var ambiColor = "#1c1c1c";
            var ambientLight = new THREE.AmbientLight(ambiColor);
            scene.add(ambiColor);

            // 创建聚光
            var spotLight0 = new THREE.SpotLight(0xcccccc);
            // 设置聚光位置
            spotLight0.position.set(-40, 60, -10);
            // 围绕平面旋转聚光
            spotLight0.lookAt(plane);
            scene.add(spotLight0);

            // 创建3D实例
            var target = new THREE.Object3D();
            // 设置位置
            target.position = new THREE.Vector3(5, 0, 0);

            // 创建聚光
            var pointColor = "#ffffff";
            var spotLight = new THREE.SpotLight(pointColor);
            // 设置位置
            spotLight.position.set(-40, 60, -10);
            // 开启阴影
            spotLight.castShadow = true;
            // 设置从距离光源哪点开始生成阴影
            spotLight.shadowCameraNear = 2;
            // 设置到距离光源的哪一点为止生成阴影
            spotLight.shadowCameraFar = 200;
            // 设置生成的视场
            spotLight.shadowCameraFor = 130;
            spotLight.target = plane;
            // 设置光的照射距离
            spotLight.distance = 0;
            scene.add(spotLight);


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
                this.intensity = 1;
                this.distance = 0;
                this.exponent = 30;
                this.angle = 0.1;
                this.debug = false;
                this.castShadow = true;
                this.onlyShadow = false;
                this.target = "Plane";
                this.stopMovingLight = false;
            }

            var gui = new dat.GUI();
            gui.addColor(controls, 'ambientColor').onChange(function (e) {
                ambientLight.color = new THREE.Color(e);
            });

            gui.addColor(controls, 'pointColor').onChange(function (e) {
                spotLight.color = new THREE.Color(e);
            });

            gui.add(controls, 'angle', 0, Math.PI * 2).onChange(function (e) {
                spotLight.angle = e;
            });

            gui.add(controls, 'intensity', 0, 5).onChange(function (e) {
                spotLight.intensity = e;
            });

            gui.add(controls, 'distance', 0, 200).onChange(function (e) {
                spotLight.distance = e;
            });

            gui.add(controls, 'exponent', 0, 100).onChange(function (e) {
                spotLight.exponent = e;
            });

            gui.add(controls, 'debug').onChange(function (e) {
                spotLight.shadowCameraVisible = e;
            });

            gui.add(controls, 'castShadow').onChange(function (e) {
                spotLight.castShadow = e;
            });

            gui.add(controls, 'onlyShadow').onChange(function (e) {
                spotLight.onlyShadow = e;
            });

            gui.add(controls, 'target', ['Plane', 'Sphere', 'Cube']).onChange(function (e) {
                console.log(e);
                switch (e) {
                    case "Plane":
                        spotLight.target = plane;
                        break;
                    case "Sphere":
                        spotLight.target = sphere;
                        break;
                    case "Cube":
                        spotLight.target = cube;
                        break;
                }

            });

            gui.add(controls, 'stopMovingLight').onChange(function (e) {
                stopMovingLight = e;
            });


            render();

            function render() {
                stats.update();
                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpeed;
                sphere.position.x = 20 + ( 10 * (Math.cos(step)));
                sphere.position.y = 2 + ( 10 * Math.abs(Math.sin(step)));

                if (!stopMovingLight) {
                    if (phase > 2 * Math.PI) {
                        invert = invert * -1;
                        phase -= 2 * Math.PI;
                    } else {
                        phase += controls.rotationSpeed;
                    }

                    sphereLightMesh.position.z = +(7 * (Math.sin(phase)));
                    sphereLightMesh.position.x = +(14 * (Math.cos(phase)));

                    if (invert < 0) {
                        var pivot = 14;
                        sphereLightMesh.position.x = (invert * (sphereLightMesh.position.x - pivot)) + pivot;
                    }
                    spotLight.position = sphereLightMesh.position;
                }

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