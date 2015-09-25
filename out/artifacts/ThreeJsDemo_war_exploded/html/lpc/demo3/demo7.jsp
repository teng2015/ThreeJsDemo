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
            // 设置场景雾化
            scene.fog = new THREE.Fog(0xaaaaaa, 0.010, 200);

            // 创建透视相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-20, 15, 45);
            // 旋转相机对象
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置渲染器背景（颜色，透明度）
            renderer.setClearColorHex(0xaaaaff, 1.0);
            // 设置渲染大小
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 开启阴影
            renderer.shadowMapEnabled = true;


            // 加载纹理
            var textureGrass = THREE.ImageUtils.loadTexture("../../../images/textures/ground/grasslight-big.jpg");
            textureGrass.wrapS = THREE.RepeatWrapping;
            textureGrass.wrapT = THREE.RepeatWrapping;
            textureGrass.repeat.set(4, 4);

            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 200, 20, 20),
                new THREE.MeshLambertMaterial({map: textureGrass})
            );
            // 开启阴影
            plane.receiveShadow = true;
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, 0, 0);
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({color: 0xff3333})
            );
            // 设置位置
            cube.position.set(-4, 3, 0);
            // 开启阴影
            cube.castShadow = true;
            scene.add(cube);

            // 创建球体
            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 25, 25),
                new THREE.MeshLambertMaterial({color: 0x7777ff})
            );
            // 设置球体位置
            sphere.position.set(10, 5, 10);
            // 开启阴影
            sphere.castShadow = true;
            scene.add(sphere);

            // 创建环境光
            var ambiColor = "#1c1c1c";
            var ambientLight = new THREE.AmbientLight(ambiColor);
            scene.add(ambientLight);

            // 创建聚光
            var spotLight0 = new THREE.SpotLight(0xcccccc);
            spotLight0.position.set(-40, 60, -10);
            // 设置聚光旋转对象
            spotLight0.lookAt(plane);
            scene.add(spotLight0);

            // 指定目标
            var target = new THREE.Object3D();
            target.position = new THREE.Vector3(5, 0, 0);

            // 创建方向光
            var pointColor = "#ffffff";
            var spotLight = new THREE.DirectionalLight(pointColor);
            spotLight.position.set(30, 10, -50);
            // 开启阴影
            spotLight.castShadow = true;
            // 设置从距离光源的那一点开始生成阴影
            spotLight.shadowCameraNear = 0.1;
            // 设置到距离光源的哪一点为止可以生成阴影
            spotLight.shadowCameraFar = 100;
            // 设置生成阴影的视场
            spotLight.shadowCameraFov = 50;
            // 设置光照的方向（指定目标）
            spotLight.target = plane;
            // 设置光源照射的距离
            spotLight.distance = 0;
            // 设置从距离光源的那一点开始生成阴影
            spotLight.shadowCameraNear = 2;
            // 设置到距离光源的哪一点为止可以生成阴影
            spotLight.shadowCameraFar = 200;
            // 相机左侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraLeft = -100;
            // 相机右侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraRight = 100;
            // 相机上侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraTop = 100;
            // 相机下侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraBottom = -100;
            // 阴影映射宽度
            spotLight.shadowMapWidth = 2048;
            // 阴影映射高度
            spotLight.shadowMapHeight = 2048;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var invet = 1;
            var phase = 0;
            var controls = new function() {
                this.rotationSpeed = 0.03;
                this.bouncingSpeed = 0.03;
                this.ambientColor = ambiColor;
                this.pointColor = pointColor;
                this.intensity = 0.1;
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
                spotLight.color = new THREE.Color(e);
            });
            gui.add(controls, "intensity", 0, 5).onChange(function(e) {
                spotLight.intensity = e;
            });


            var textureFlare0 = THREE.ImageUtils.loadTexture("../../../images/textures/lensflare/lensflare0.png");
            var textureFlare3 = THREE.ImageUtils.loadTexture("../../../images/textures/lensflare/lensflare3.png");

            var flareColor = new THREE.Color(0xffaacc);
            var lensFlare = new THREE.LensFlare(textureFlare0, 350, 0.0, THREE.AdditiveBlending, flareColor);

            lensFlare.add(textureFlare3, 60, 0.6, THREE.AdditiveBlending);
            lensFlare.add(textureFlare3, 70, 0.7, THREE.AdditiveBlending);
            lensFlare.add(textureFlare3, 120, 0.9, THREE.AdditiveBlending);
            lensFlare.add(textureFlare3, 70, 1.0, THREE.AdditiveBlending);

            lensFlare.position = spotLight.position;
            scene.add(lensFlare);

            render();

            function render() {
                stats.update();
                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpeed;
                sphere.position.x = 20 + (10 * (Math.cos(step)));
                sphere.position.y = 2 + (10 * Math.abs(Math.sin(step)));

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