import input_mnist_data
import tensorflow as tf

data_sets = input_mnist_data.read_data_sets(FLAGS.train_dir, FLAGS.fake_data)
