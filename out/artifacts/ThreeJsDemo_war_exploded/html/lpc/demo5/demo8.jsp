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

            var scene = new THREE.Scene();

            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.set(-30, 40, 50);
            camera.lookAt(10, 0, 0);

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setScissor(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            var knot = createMesh(new THREE.TorusKnotGeometry(10, 1));
            scene.add(knot);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.radius = knot.children[0].geometry.radius;
                this.tube = 0.3;
                this.radialSegments = knot.children[0].geometry.radialSegments;
                this.tubularSegments = knot.children[0].geometry.tubularSegments;
                this.p  = knot.children[0].geometry.p;
                this.q = knot.children[0].geometry.q;
                this.heightScale = knot.children[0].geometry.heightScale;

                this.redraw = function() {
                    scene.remove(knot);
                    knot = createMesh(new THREE.TorusKnotGeometry(
                            controls.radius,
                            controls.tube,
                            Math.round(controls.radialSegments),
                            Math.round(controls.tubularSegments),
                            Math.round(controls.p),
                            Math.round(controls.q),
                            controls.heightScale
                    ));
                    scene.add(knot);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "radius", 0, 40).onChange(controls.redraw);
            gui.add(controls, "tube", 0, 40).onChange(controls.redraw);
            gui.add(controls, "radialSegments", 0, 400).step(1).onChange(controls.redraw);
            gui.add(controls, "tubularSegments", 1, 20).step(1).onChange(controls.redraw);4
            gui.add(controls, "p", 1, 10).step(1).onChange(controls.redraw);
            gui.add(controls, "q", 1, 15).step(1).onChange(controls.redraw);
            gui.add(controls, "heightScale", 0, 5).onChange(controls.redraw);

            render();

            function createMesh(geom) {
                var meshMaterial = new THREE.MeshNormalMaterial();
                meshMaterial.side = THREE.DoubleSide;
                var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial])
                return mesh;
            }

            function render() {
                stats.update();
                knot.rotation.y = step += 0.01;
                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function initStats() {
                var stats = new Stats();
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