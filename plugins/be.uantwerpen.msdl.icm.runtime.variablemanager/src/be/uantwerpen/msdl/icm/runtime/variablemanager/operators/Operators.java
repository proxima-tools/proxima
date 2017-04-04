package be.uantwerpen.msdl.icm.runtime.variablemanager.operators;

import net.objecthunter.exp4j.operator.Operator;
import java.util.List;

public class Operators {

	public static Operator gteq = new Operator(">=", 2, true, Operator.PRECEDENCE_ADDITION - 1) {

		@Override
		public double apply(double[] values) {
			if (values[0] >= values[1]) {
				return 1d;
			} else {
				return 0d;
			}
		}
	};

	public static Operator gt = new Operator(">", 2, true, Operator.PRECEDENCE_ADDITION - 1) {

		@Override
		public double apply(double[] values) {
			if (values[0] > values[1]) {
				return 1d;
			} else {
				return 0d;
			}
		}
	};

	public static Operator lteq = new Operator("<=", 2, true, Operator.PRECEDENCE_ADDITION - 1) {

		@Override
		public double apply(double[] values) {
			if (values[0] <= values[1]) {
				return 1d;
			} else {
				return 0d;
			}
		}
	};

	public static Operator lt = new Operator("<", 2, true, Operator.PRECEDENCE_ADDITION - 1) {

		@Override
		public double apply(double[] values) {
			if (values[0] < values[1]) {
				return 1d;
			} else {
				return 0d;
			}
		}
	};

	public static Operator eq = new Operator("=", 2, true, Operator.PRECEDENCE_ADDITION - 1) {

		@Override
		public double apply(double[] values) {
			if (values[0] == values[1]) {
				return 1d;
			} else {
				return 0d;
			}
		}
	};
}
