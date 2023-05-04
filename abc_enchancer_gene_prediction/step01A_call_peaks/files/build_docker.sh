git clone https://github.com/workflow-development-interest-group/wdig-ABC-Enhancer-Gene-Prediction.git

cp Dockerfile wdig-ABC-Enhancer-Gene-Prediction
cd wdig-ABC-Enhancer-Gene-Prediction/
docker build -t images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023050101 ./

#docker login images.sb.biodatacatalyst.nhlbi.nih.gov -u dave -p [token]
#docker push images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023050101