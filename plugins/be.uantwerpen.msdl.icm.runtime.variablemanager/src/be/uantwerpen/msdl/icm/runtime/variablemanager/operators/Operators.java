/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.icm.runtime.variablemanager.operators;

import net.objecthunter.exp4j.operator.Operator;

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
