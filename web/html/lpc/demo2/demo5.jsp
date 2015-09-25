<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ConvexGeometry.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ParametricGeometries.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>
    <title>Insert title here</title>

    <script type="text/javascript">

        $(function() {
            // 调用帧插件
            var stats = initStats();

            // 创建一个场景
            var scene = new THREE.Scene();

            // 创建一个相机  视场（推荐45度）,长宽比（推荐width/height）,近面（推荐0.1开始渲染）,远面（推荐1000）
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-20, 25, 20);
            camera.lookAt(new THREE.Vector3(5, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置背景和透明度
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置宽度和高度
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 是否允许阴影映射
            renderer.shadowMapEnabled = true;


            // 创建立方体
            var planeGeometry = new THREE.PlaneGeometry(60, 40, 1, 1);
            var planeMaterial = new THREE.MeshLambertMaterial({color: 0xffffff});
            var plane = new THREE.Mesh(planeGeometry, planeMaterial);
            // 是否支持阴影覆盖
            plane.receiveShadow = true;
            // 设置立方体沿x旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置立方体位置
            plane.position.set(0, 0, 0);
            scene.add(plane);

            // 创建光源（环境光）
            var ambientLight = new THREE.AmbientLight(0x090909);
            scene.add(ambientLight);

            // 创建光源（聚光灯光源）
            var spotLight = new THREE.SpotLight( 0xffffff );
            spotLight.position.set( -40, 60, 10 );
            spotLight.castShadow = true;
            scene.add( spotLight );

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            // 创建点
            var vertices = [
                new THREE.Vector3(1, 3, 1),
                new THREE.Vector3(1, 3, -1),
                new THREE.Vector3(1, -1, 1),
                new THREE.Vector3(1, -1, -1),
                new THREE.Vector3(-1, 3, -1),
                new THREE.Vector3(-1, 3, 1),
                new THREE.Vector3(-1, -1, -1),
                new THREE.Vector3(-1, -1, 1)
            ];

            // 创建面
            var faces = [
                new THREE.Face3(0, 2, 1),
                new THREE.Face3(2, 3, 1),
                new THREE.Face3(4, 6, 5),
                new THREE.Face3(6, 7, 5),
                new THREE.Face3(4, 5, 1),
                new THREE.Face3(5, 0, 1),
                new THREE.Face3(7, 6, 2),
                new THREE.Face3(6, 3, 2),
                new THREE.Face3(5, 7, 0),
                new THREE.Face3(7, 2, 0),
                new THREE.Face3(1, 3, 4),
                new THREE.Face3(3, 6, 4),
            ];

            var geom = new THREE.Geometry();
            geom.vertices = vertices;
            geom.faces = faces;

            geom.computeCentroids();
            geom.mergeVertices();

            var materials = [
                new THREE.MeshLambertMaterial( { opacity:0.6, color: 0x44ff44, transparent:true } ),
                new THREE.MeshBasicMaterial( { color: 0x000000, wireframe: true } )

            ];

            var mesh = THREE.SceneUtils.createMultiMaterialObject(geom,materials);
            mesh.children.forEach(function(e) {
                e.castShadow = true
            });

            scene.add(mesh);

            function addControl(x, y, z) {
                var controls = new function() {
                    this.x = x;
                    this.y = y;
                    this.z = z;
                }
                return controls;
            }

            var controlPoints = [];
            controlPoints.push(addControl(3,5,3));
            controlPoints.push(addControl(3,5,0));
            controlPoints.push(addControl(3,0,3));
            controlPoints.push(addControl(3,0,0));
            controlPoints.push(addControl(0,5,0));
            controlPoints.push(addControl(0,5,3));
            controlPoints.push(addControl(0,0,0));
            controlPoints.push(addControl(0,0,3));

            var gui = new dat.GUI();
            gui.add(new function () {
                this.clone = function () {

                    var cloned = mesh.children[0].geometry.clone();
                    var materials = [
                        new THREE.MeshLambertMaterial({opacity: 0.6, color: 0xff44ff, transparent: true}),
                        new THREE.MeshBasicMaterial({color: 0x000000, wireframe: true})

                    ];

                    var mesh2 = THREE.SceneUtils.createMultiMaterialObject(cloned, materials);
                    mesh2.children.forEach(function (e) {
                        e.castShadow = true
                    });

                    mesh2.translateX(5);
                    mesh2.translateZ(5);
                    mesh2.name = "clone";
                    scene.remove(scene.getChildByName("clone"));
                    scene.add(mesh2);
                }
            }, 'clone');

            for (var i = 0; i < 8; i++) {
                f1 = gui.addFolder('Vertices ' + (i + 1));
                f1.add(controlPoints[i], 'x', -10, 10);
                f1.add(controlPoints[i], 'y', -10, 10);
                f1.add(controlPoints[i], 'z', -10, 10);
            }

            render();

            function addCube() {

            }


            // 渲染
            function render() {
                stats.update();

                var vertices = [];
                var vertices = [];
                for (var i = 0 ; i < 8 ; i++) {
                    vertices.push(new THREE.Vector3(controlPoints[i].x, controlPoints[i].y,controlPoints[i].z));
                }

                mesh.children.forEach(function(e) {
                    e.geometry.vertices=vertices;
                    e.geometry.verticesNeedUpdate=true;
                    e.geometry.computeFaceNormals();
                });

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            // 帧插件
            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = 'absolute';
                stats.domElement.style.left = '0px';
                stats.domElement.style.top = '0px';

                $("#Stats-output").append( stats.domElement );
                return stats;
            }

        })



    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>